//
//  SettingsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Button {
                viewModel.signOut()
            } label: {
                Text("Sign out")
            }
        }
        .background {
            Color.ContentPrimary.background
                .ignoresSafeArea()
        }
    }
}
