//
//  ChannelClientModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 1/7/24.
//

import Foundation

public struct ChannelClientModel: Codable {
    public init(identifier: String, ownerId: String, name: String, description: String, imageUrl: URL?, creationDate: Date?, lastUpdateDate: Date?, channelInvitationMode: String) {
        self.identifier = identifier.lowercased()
        self.ownerId = ownerId
        self.name = name
        self.description = description
        self.searchSegments = Self.makeSearchSegments(
            name: name.lowercased(),
            description: description.lowercased(),
            identifier: identifier.lowercased())
        self.imageUrl = imageUrl
        self.createdAt = creationDate
        self.updatedAt = lastUpdateDate
        self.channelInvitationMode = channelInvitationMode
    }
    
    public let identifier: String
    public let ownerId: String
    public let name: String
    public let searchSegments: [String]
    public let description: String
    public let imageUrl: URL?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let channelInvitationMode: String
    
    private static func makeSearchSegments(name: String, description: String, identifier: String) -> [String] {
        let nameSegments = name.components(separatedBy: " ")
        let descriptionSegments = description.components(separatedBy: " ")
        
        let nameSegmentsWithSubSegments = addSubSegments(input: nameSegments)
        
        return nameSegmentsWithSubSegments + descriptionSegments + [identifier]
    }
    
    private static func addSubSegments(input: [String]) -> [String] {
        var result = input
        
        for string in input where string.count > 2 {
            var mutable = string
            
            while mutable.count > 2 {
                result.append(mutable)
                mutable.removeFirst()
            }
        }
        
        return result
    }
}
