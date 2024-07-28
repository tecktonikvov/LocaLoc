//
//  ChannelSettingsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 28/7/24.
//

import SwiftUI

struct ChannelSettingsView: View {
    @Binding var selected: ChannelInvitationMode
    @State var availableInvitationModes: [ChannelInvitationMode]

    var body: some View {
        Picker("Channel type", selection: $selected) {
            ForEach(availableInvitationModes, id: \.self) { option in
                Text(option.title)
            }
        }
    }
}
