//
//  HomeViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import K_Logger
import Factory

struct HomeModel {
    let tabScenes: [TabScene<AnyView>]
}

@Observable class HomeViewModel {
    @ObservationIgnored
    @Injected(\.channelsRepository) var channelsRepository
    
    @ObservationIgnored
    @Injected(\.channelsClient) var channelsClient
    
    @ObservationIgnored
    @Injected(\.channelPointsClient) var channelPointsClient
    
    private(set) var model: HomeModel
    private(set) var deeplinkChannel: DeeplinkChannel?

    // MARK: - Init
    init(model: HomeModel) {
        self.model = model
        subscribeToDeepLinksUpdates()
    }
    
    // MARK: - Private
    private func subscribeToDeepLinksUpdates() {
        InMemoryDeeplinkHolder.onChannelDeepLinkSet = { [weak self] channelDeeplink in
            Log.info("Deeplink received, processing..", module: "HomeViewModel")
            self?.handleChannelDeepLink(channelDeeplink: channelDeeplink)
        }
    }
    
    private func doesUserSubscribed(on channel: Channel) -> Bool {
        channelsRepository.channels.contains(channel)
    }
    
    private func invitation() async throws -> Invitation? {
        let invitation = Invitation.mock
        guard invitation.usedAt == nil else { return nil }
        return invitation
    }
    
    private func handleChannelDeepLink(channelDeeplink: ChannelDeeplinkModel) {
        let channelId = channelDeeplink.channelId
        
        guard !channelId.isEmpty else { return }
        
        self.deeplinkChannel = nil
        InMemoryDeeplinkHolder.channelDeepLink = nil
        
        Task { @MainActor in
            do {
                guard let channel = try await channelsRepository.fetchChannel(withId: channelId) else {
                    return
                }
                
                // If user already subscribed show channel.
                guard !doesUserSubscribed(on: channel) else {
                    self.deeplinkChannel = .accessAllowed(channel, relationType: .subscribed)
                    return
                }
                
                switch channel.channelSettings.invitationMode {
                case .open:
                    self.deeplinkChannel = .accessAllowed(channel, relationType: .notSubscribed)
                case .byInvitation:
                    // If user has an invitation show channel with ability to subscribe with invitation.
                    if let invitation = try await invitation() {
                        self.deeplinkChannel = .accessAllowed(channel, relationType: .invited(invitation))
                    } else {
                        // If user has no invitation limit access.
                        async let participantsNumber = try channelsClient.channelParticipantsNumber(channelId: channel.id)
                        async let pointsNumber = try channelPointsClient.channelPointsNumber(channelId: channel.id)
                        
                        let privateChannelModel = PrivateChannelModel(
                            channel: channel,
                            pointsNumber: try await pointsNumber,
                            participantsNumber: try await participantsNumber
                        )
                        self.deeplinkChannel = .accessDenied(privateChannelModel)
                    }
                }
            } catch {
                Log.error("Channel request error: \(error)", module: "HomeViewModel")
            }
        }
    }
    
    // MARK: - Public
    func checkForDeepLinks(delay: TimeInterval) {
        guard let channelDeepLink = InMemoryDeeplinkHolder.channelDeepLink else { return }
        Log.info("Home appeared, deeplink detected, processing..", module: "HomeViewModel")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.handleChannelDeepLink(channelDeeplink: channelDeepLink)
        }
    }
}
