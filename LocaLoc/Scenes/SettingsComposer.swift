//
//  SettingsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class SettingsComposer: SceneComposer {
    static func compose(
        authenticationService: AuthenticationService,
        user: User,
        userDataRepository: UserDataRepository,
        usernameManager: UsernameManager
    ) -> TabScene<AnyView> {
        let viewModel = SettingsViewModel(
            user: user,
            authenticationService: authenticationService
        )
        
        let view = SettingsView(
            viewModel: viewModel,
            userDataRepository: userDataRepository,
            usernameManager: usernameManager
        )
        
        return TabScene(type: .settings) {
            AnyView(view)
        }
    }
}
