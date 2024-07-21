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
                
                switch channel.channelSettings.invitationMode {
                case .open:
                    self.deeplinkChannel = .openChannel(channel)
                case .byInvitation:
                    if doesUserSubscribed(on: channel) {
                        self.deeplinkChannel = .openChannel(channel)
                    } else {
                        async let participantsNumber = try channelsClient.channelParticipantsNumber(channelId: channel.id)
                        async let pointsNumber = try channelPointsClient.channelPointsNumber(channelId: channel.id)
                        
                        let privateChannelModel = PrivateChannelModel(
                            channel: channel,
                            pointsNumber: try await pointsNumber,
                            participantsNumber: try await participantsNumber
                        )
                        self.deeplinkChannel = .privateChannel(privateChannelModel)
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
