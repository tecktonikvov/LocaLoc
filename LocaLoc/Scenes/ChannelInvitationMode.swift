//
//  ChannelInvitationMode.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import SwiftUI

enum ChannelInvitationMode: String, CaseIterable {
    case open
    case byInvitation
}

extension ChannelInvitationMode {
    var title: LocalizedStringKey {
        switch self {
        case .open:
            return "Open"
        case .byInvitation:
            return "By invitation"
        }
    }
}
