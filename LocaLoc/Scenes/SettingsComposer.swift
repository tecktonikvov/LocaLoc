//
//  SettingsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class SettingsComposer: SceneComposer {
    static func compose(user: User, path: Binding<NavigationPath>) -> TabScene<AnyView> {
        let viewModel = SettingsViewModel(user: user)
        
        let view = SettingsView(viewModel: viewModel, path: path)
        
        return TabScene(type: .settings) {
            AnyView(view)
        }
    }
}
