//
//  Channel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import Foundation

@Observable final class ChannelSettings {
    init(invitationMode: ChannelInvitationMode) {
        self.invitationMode = invitationMode
    }
    
    let invitationMode: ChannelInvitationMode

    static let `default` = ChannelSettings(invitationMode: .open)
}

@Observable final class ChannelUserSettings {
    init(isMuted: Bool) {
        self.isMuted = isMuted
    }
    
    let isMuted: Bool
    
    static let `default` = ChannelUserSettings(isMuted: false)
}

@Observable final class Channel: Equatable {
    init(id: String, identifier: String, ownerId: String, name: String, description: String, imageUrl: URL?, missedUpdatesNumber: Int, creationDate: Date?, lastUpdateDate: Date?, channelSettings: ChannelSettings, userSettings: ChannelUserSettings, channelPoints: [ChannelPoint]) {
        self.id = id
        self.identifier = identifier
        self.ownerId = ownerId
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.missedUpdatesNumber = missedUpdatesNumber
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.channelSettings = channelSettings
        self.userSettings = userSettings
        self.channelPoints = channelPoints
    }
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    let identifier: String
    let ownerId: String
    let name: String
    let description: String
    var imageUrl: URL?
    let missedUpdatesNumber: Int
    let creationDate: Date?
    var lastUpdateDate: Date?
    let channelSettings: ChannelSettings
    let userSettings: ChannelUserSettings
    var channelPoints: [ChannelPoint]
}

extension Channel: Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}

extension Channel {
    static let mock: [Channel] = [
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString, 
            ownerId: UUID().uuidString,
            name: "Tech News",
            description: "Latest updates in tech",
            imageUrl: URL(
                string: "https://cdn.pixabay.com/photo/2015/06/24/15/45/code-820275_1280.jpg"
            ),
            missedUpdatesNumber: 5,
            creationDate: nil,
            lastUpdateDate: Date(),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true), 
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Daily Sports",
            description: "Sports highlights",
            imageUrl: URL(
                string: "https://cdn.pixabay.com/photo/2016/11/29/09/32/football-1869945_1280.jpg"
            ),
            missedUpdatesNumber: 12,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -3600
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Movie Reviews",
            description: "Latest movie reviews",
            imageUrl: nil,
            missedUpdatesNumber: 0,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -14400
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Gaming World",
            description: "Gaming news and reviews",
            imageUrl: URL(
                string: "https://picsum.photos/id/237/200/300"
            ),
            missedUpdatesNumber: 6,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -2520000000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Movie Reviews Movie ReviewsMovie Reviews Movie Reviews Movie Reviews",
            description: "Latest movie reviews, Latest movie reviews Latest movie reviewsLatest movie reviews",
            imageUrl: nil,
            missedUpdatesNumber: 0,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -144000000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Gaming World",
            description: "Gaming news and reviews",
            imageUrl: URL(
                string: "https://picsum.photos/seed/picsum/200/300"
            ),
            missedUpdatesNumber: 111,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -25200000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Movie Reviews",
            description: "Latest movie reviews",
            imageUrl: nil,
            missedUpdatesNumber: 88,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -1440000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        ),
        Channel(
            id: UUID().uuidString,
            identifier: UUID().uuidString,
            ownerId: UUID().uuidString,
            name: "Gaming World",
            description: "Gaming news and reviews",
            imageUrl: URL(
                string: "https://example.com/image8.png"
            ),
            missedUpdatesNumber: 6,
            creationDate: nil,
            lastUpdateDate: Date().addingTimeInterval(
                -252000
            ),
            channelSettings: .default,
            userSettings: ChannelUserSettings(isMuted: true),
            channelPoints: []
        )
    ]
}
