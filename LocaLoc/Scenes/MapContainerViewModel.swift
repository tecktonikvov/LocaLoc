//
//  MapContainerViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import Factory
import Foundation
import LocaLocClient
import K_Logger

struct SelectedPointData: Equatable {
    let point: ChannelPoint
    let markerFrame: CGRect
}

enum SelectedPointSingType {
    case `default`
    case emoji
}

fileprivate enum SubscriptionRequestError: Error {
    case invitationExpired
    case invitationUsed
    case invitationIsMissed
}

@Observable final class MapContainerViewModel {
    @ObservationIgnored
    private(set) var mapView: MapViewController
 
    @ObservationIgnored
    private(set) var selectedCoordinates: Coordinates?
    
    @ObservationIgnored
    private var mapController: MapController
    
    @ObservationIgnored
    private lazy var channelPointsRepository = Container.shared.channelPointsRepository(channel)

    @ObservationIgnored
    @Injected(\.userIdProvider) private var userIdProvider
    
    @ObservationIgnored
    @Injected(\.channelsRepository) private var channelsRepository
    
    @ObservationIgnored
    @Injected(\.invitationClient) private var invitationClient
    
    @ObservationIgnored
    @Injected(\.channelsClient) private var channelsClient
    
    var dismiss = false
    var showAddPointView = false
    var showPointEditingView = false
    var showSynchronizationIndicator = false
    var pointCreationRequestInProgress = false
    var showSubscriptionRequestIndicator = false
    
    var showInvitationUsedPopUp = false
    var showInvitationExpiredPopUp = false

    // New point properties
    var showPoint: Bool = false
    var description: String = ""
    var addressString: String = ""
    var lifetime: Int? // Not implemented
    var emojiCode: String = "😀"
    var heading: Double? // Not implemented
    var selectedPointSingType: SelectedPointSingType = .default
    
    private(set) var selectedPointData: SelectedPointData?
    private(set) var pointEditingViewModel: PointEditingViewModel?

    private(set) var channel: Channel
    private(set) var userSubscriptionRelationType: UserChannelSubscriptionRelationType

    private var currentUserId: String = ""
    
    var mapTopSafeAreaInset: CGFloat {
        mapController.mapView.safeAreaInsets.top
    }
    
    private var isChannelOwner: Bool {
        channel.ownerId == currentUserId
    }
    
    private let membersNumber = 12

    // MARK: - Init
    init(channel: Channel, userSubscriptionRelationType: UserChannelSubscriptionRelationType) {
        self.channel = channel
        self.userSubscriptionRelationType = userSubscriptionRelationType

        let mapController = MapController()
        self.mapController = mapController
        
        let mapViewController = MapViewController(mapView: mapController.mapView)
        self.mapView = mapViewController
                
        mapController.delegate = self
        
        Task {
            currentUserId = try userIdProvider.userId()
        }
    }
    
    // MARK: - Private
    private func clearCurrentPointData() {
        description = ""
        addressString = ""
        lifetime = nil
        emojiCode = "😀"
        heading = nil
        showPoint = false
        selectedPointSingType = .default
    }
    
    private func makePointEditingViewModel(for point: ChannelPoint) -> PointEditingViewModel {
        let viewModel = PointEditingViewModel(
            channelPoint: point,
            channelPointsRepository: channelPointsRepository
        )
        
        viewModel.onClose = { [weak self] in
            self?.removePointEditingViewModel()
            self?.showPointEditingView = false
        }
        
        viewModel.onSuccess = { [weak self] in
            self?.updateMarkersOnMap()
            self?.showPointEditingView = false
        }
        
        viewModel.onDeleted = { [weak self] in
            self?.updateMarkersOnMap()
            self?.clearSelectedPoint()
            self?.showPointEditingView = false
        }
        
        return viewModel
    }
    
    private func clearSelectedPoint() {
        guard selectedPointData != nil else { return }
        self.selectedPointData = nil
    }
    
    private func updateMarkersOnMap() {
        let updatedPoints = channelPointsRepository.points
        mapController.updateMarkersIfNeeded(points: updatedPoints)
    }
    
    private func validate(invitation: Invitation) async throws {
        let currentInvitationModel = try await invitationClient.invitation(withId: invitation.id)
        
        guard let currentInvitationModel else {
            throw SubscriptionRequestError.invitationIsMissed
        }
        
        // Check if invitation expired
        let current = Date.timeZoneIndependentCurrentDate.timeIntervalSince1970
        let invitationExistenceTime = current - currentInvitationModel.createdAt.timeIntervalSince1970
        
        guard invitationExistenceTime < Constants.invitationLifeTime else {
            throw SubscriptionRequestError.invitationExpired
        }
        
        // Check if invitation was used
        guard currentInvitationModel.usedAt == nil else {
            throw SubscriptionRequestError.invitationUsed
        }
    }
    
    private func subscriptionRequest() async throws {
        let userId = try userIdProvider.userId()
        
        let participantModel = ChannelParticipantClientModel(
            userId: userId,
            channelId: channel.id,
            createdAt: Date.timeZoneIndependentCurrentDate,
            updatedAt: Date.timeZoneIndependentCurrentDate
        )
        
        try await channelsClient.createChannelParticipant(channelParticipantClientModel: participantModel)
    }
    
    private func pointsCount() -> Int {
        if isChannelOwner {
            return mapController
                .markers
                .count
        } else {
            return mapController
                .markers
                .filter { !$0.isHidden }
                .count
        }
    }

    // MARK: - Public
    func backButtonTapped() {
        dismiss = true
    }
    
    func settingsButtonTapped() {
        
    }
    
    func recenterButtonTapped() {
        mapController.goToMyLocation()
    }
    
    func subscribe() {
        showSubscriptionRequestIndicator = true
        
        Task { @MainActor in
            do {                
                if let invitation = userSubscriptionRelationType.invitation {
                    try await validate(invitation: invitation)
                }
                
                try await subscriptionRequest()
                try await channelsRepository.synchronizeUserChannelsList()
                
                userSubscriptionRelationType = .subscribed
                // Add subscriber number
            } catch {
                if let error = error as? SubscriptionRequestError {
                    switch error {
                    case .invitationExpired:
                        showInvitationExpiredPopUp = true
                    case .invitationUsed:
                        showInvitationUsedPopUp = true
                    case .invitationIsMissed:
                        Log.error("Try to subscribe but invitation in nil", module: "MapContainerViewModel")
                    }
                } else {
                    Log.error("Subscription error: \(error)", module: "MapContainerViewModel")
                }
            }
            
            showSubscriptionRequestIndicator = false
        }
    }
    
    func newPointApproved() {
        Task { @MainActor in
            guard let newSelectedMarker = mapController.newSelectedMarker else { return }
            let emojiCode = selectedPointSingType == .emoji ? emojiCode : nil

            pointCreationRequestInProgress = true

            newSelectedMarker.emojiCode = emojiCode
            newSelectedMarker.isHidden = !showPoint

            do {
                let point = ChannelPoint(
                    id: UUID().uuidString,
                    channelId: channel.id,
                    latitude: newSelectedMarker.coordinates.latitude,
                    longitude: newSelectedMarker.coordinates.longitude,
                    address: addressString,
                    description: description,
                    creatorId: currentUserId,
                    createdAt: Date.timeZoneIndependentCurrentDate,
                    updatedAt: Date.timeZoneIndependentCurrentDate,
                    heading: heading,
                    lifeTime: lifetime,
                    emojiCode: emojiCode,
                    isHidden: !showPoint
                )
                
                let pointWithId = try await channelPointsRepository.saveChannelPoint(point)
                mapController.replaceNewSelectedPoint(by: pointWithId)
                
                self.channel.channelPoints.append(pointWithId)
                Haptic.perform(.success)
                
                clearCurrentPointData()
            } catch {
                print("🔴", error)
                Haptic.perform(.error)
            }
            
            showAddPointView = false
            pointCreationRequestInProgress = false
        }
    }
    
    func newPointCanceled() {
        mapController.removeNewSelectedPoint()
        showAddPointView = false
    }
    
    func addChannelPoints() {
        let points = channelPointsRepository.points
        mapController.addMarkers(forPoints: points)
    }
    
    func pointEditButtonTaped() {
        guard let point = selectedPointData?.point else { return }
        
        self.pointEditingViewModel = makePointEditingViewModel(for: point)
                
        showPointEditingView = true
        
        mapController.focusCamera(on: point)
    }
    
    func removePointEditingViewModel() {
        self.pointEditingViewModel = nil
    }
    
    func isEditingAllowed() -> Bool {
        guard !currentUserId.isEmpty && !channel.ownerId.isEmpty else {
            return false
        }
        return currentUserId == channel.ownerId
    }
    
    func channelDetailsModel() -> ChannelDetailsModel {
        ChannelDetailsModel(
            channel: channel,
            pointsNumber: pointsCount(),
            participantsNumber: 12
        )
    }
    
    // MARK: - Public
    func synchronizeChannelsPoints() {
        self.showSynchronizationIndicator = true
        
        Task { @MainActor in
            do {
                try await channelPointsRepository.synchronizeUserChannelPointsList()
                mapController.clearMarkers()
                addChannelPoints()
            } catch {
                print("🔴", error)
            }
            
            self.showSynchronizationIndicator = false
        }
    }
}

// MARK: - MapControllerDelegate
extension MapContainerViewModel: MapControllerDelegate {
    func didTapOnMarker(withId pointId: String, markerViewFrame: CGRect) {
        if self.selectedPointData != nil {
            self.selectedPointData = nil
        }
        
        DispatchQueue.main.async {
            guard let selectedPoint = self.channelPointsRepository.points.first(where: { $0.id == pointId }) else {
                return
            }
            
            self.selectedPointData = SelectedPointData(point: selectedPoint, markerFrame: markerViewFrame)
        }
    }
    
    func didChangeCameraPosition() {
        clearSelectedPoint()
    }
    
    func didAddNewMarker(coordinates: Coordinates) {
        Haptic.perform()
        selectedCoordinates = coordinates
        showAddPointView = true
    }
}
