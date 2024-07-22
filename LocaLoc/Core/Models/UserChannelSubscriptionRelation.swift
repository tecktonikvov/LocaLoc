//
//  UserChannelSubscriptionRelation.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import Foundation

/// Shows user subscription relation type to some channel
enum UserChannelSubscriptionRelationType: Hashable {
    /// User subscribed on channel
    case subscribed
    
    /// User has nor relations. He does not subscribed
    case notSubscribed
    
    /// User has invitation to channel
    case invited(Invitation)
    
    var invitation: Invitation? {
        switch self {
        case .subscribed, .notSubscribed:
            return nil
        case .invited(let invitation):
            return invitation
        }
    }
}
