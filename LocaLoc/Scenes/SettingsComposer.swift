//
//  SettingsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class SettingsComposer: SceneComposer {
    static func compose(authenticationService: AuthenticationService) -> TabScene<AnyView> {
        let viewModel = SettingsViewModel(authenticationService: authenticationService, dataRepository: .shared)
        let view = SettingsView(viewModel: viewModel)
        
        return TabScene(type: .settings) {
            AnyView(view)
        }
    }
}
