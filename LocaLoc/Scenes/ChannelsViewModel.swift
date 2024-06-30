//
//  ChannelsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Combine
import Foundation

struct ChannelsModel {
    let channels: [Channel]
    
    static let mock = ChannelsModel(channels: mockChannels)
    
    static let mockChannels: [Channel] = [
        Channel(
            id: UUID().uuidString,
            title: "Tech News",
            subtitle: "Latest updates in tech",
            imageUrl: URL(
                string: "https://cdn.pixabay.com/photo/2015/06/24/15/45/code-820275_1280.jpg"
            ),
            missedUpdatesNumber: 5,
            lastUpdateTime: Date(),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Daily Sports",
            subtitle: "Sports highlights",
            imageUrl: URL(
                string: "https://cdn.pixabay.com/photo/2016/11/29/09/32/football-1869945_1280.jpg"
            ),
            missedUpdatesNumber: 12,
            lastUpdateTime: Date().addingTimeInterval(
                -3600
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Movie Reviews",
            subtitle: "Latest movie reviews",
            imageUrl: nil,
            missedUpdatesNumber: 0,
            lastUpdateTime: Date().addingTimeInterval(
                -14400
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Gaming World",
            subtitle: "Gaming news and reviews",
            imageUrl: URL(
                string: "https://picsum.photos/id/237/200/300"
            ),
            missedUpdatesNumber: 6,
            lastUpdateTime: Date().addingTimeInterval(
                -2520000000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Movie Reviews Movie ReviewsMovie Reviews Movie Reviews Movie Reviews",
            subtitle: "Latest movie reviews, Latest movie reviews Latest movie reviewsLatest movie reviews",
            imageUrl: nil,
            missedUpdatesNumber: 0,
            lastUpdateTime: Date().addingTimeInterval(
                -144000000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Gaming World",
            subtitle: "Gaming news and reviews",
            imageUrl: URL(
                string: "https://picsum.photos/seed/picsum/200/300"
            ),
            missedUpdatesNumber: 111,
            lastUpdateTime: Date().addingTimeInterval(
                -25200000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Movie Reviews",
            subtitle: "Latest movie reviews",
            imageUrl: nil,
            missedUpdatesNumber: 88,
            lastUpdateTime: Date().addingTimeInterval(
                -1440000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true)
        ),
        Channel(
            id: UUID().uuidString,
            title: "Gaming World",
            subtitle: "Gaming news and reviews",
            imageUrl: URL(
                string: "https://example.com/image8.png"
            ),
            missedUpdatesNumber: 6,
            lastUpdateTime: Date().addingTimeInterval(
                -252000
            ),
            channelSettings: .default, 
            userSettings: ChannelUserSettings(isMuted: true)
        )
        ]
}

struct ChannelSettings {
    let invitationMode: ChannelInvitationMode

    static let `default` = ChannelSettings(invitationMode: .open)
}

struct ChannelUserSettings {
    let isMuted: Bool
}

struct Channel: Identifiable, Equatable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let title: String
    let subtitle: String
    let imageUrl: URL?
    let missedUpdatesNumber: Int
    let lastUpdateTime: Date
    let channelSettings: ChannelSettings
    let userSettings: ChannelUserSettings
}

@Observable final class ChannelsViewModel {
    private(set) var error: Error? = nil

    private(set) var model: ChannelsModel
    let didNavigateBack = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init() {
        self.model = ChannelsModel.mock
    }

    func backAction() {
        didNavigateBack.send(())
    }
}
