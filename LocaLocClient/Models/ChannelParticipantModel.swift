//
//  ChannelParticipantModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import Foundation

public struct ChannelParticipantModel: Codable {
    public init(id: String) {
        self.id = id
    }
    
    public let id: String
}
