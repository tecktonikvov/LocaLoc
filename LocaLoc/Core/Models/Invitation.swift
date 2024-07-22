//
//  Invitation.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import Foundation

struct Invitation: Hashable {
    let id: String
    let createdAt: Date
    let usedAt: Date?
    let creatorId: String
    let channelId: String
    
    static let mock = Invitation(id: UUID().uuidString, createdAt: Date(), usedAt: nil, creatorId: "", channelId: "")
}
