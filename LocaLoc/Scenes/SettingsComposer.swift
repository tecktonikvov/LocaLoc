//
//  SettingsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class SettingsComposer: SceneComposer {
    static func compose(authenticationService: AuthenticationService, user: User, userDataRepository: UserDataRepository) -> TabScene<AnyView> {
        let viewModel = SettingsViewModel(user: user, authenticationService: authenticationService)
        let view = SettingsView(viewModel: viewModel, userDataRepository: userDataRepository)
        
        return TabScene(type: .settings) {
            AnyView(view)
        }
    }
}
