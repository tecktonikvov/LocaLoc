//
//  HomeComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class HomeComposer: SceneComposer {
    @ViewBuilder static func view(
        authenticationService: AuthenticationService,
        userDataRepository: UserDataRepository,
        usernameManager: UsernameManager) -> some View {
            let channelsScene = ChannelsComposer.compose()
            
            let settingsScene = settingsScene(
                userDataRepository: userDataRepository,
                authenticationService: authenticationService,
                usernameManager: usernameManager
            )
            
            let scenes = [channelsScene, settingsScene].compactMap { $0 }
            let model = HomeModel(tabScenes: scenes)
            
            let viewModel = HomeViewModel(model: model)
            
            HomeView(viewModel: viewModel)
        }
    
    private static func settingsScene(
        userDataRepository: UserDataRepository,
        authenticationService: AuthenticationService,
        usernameManager: UsernameManager) -> TabScene<AnyView>? {
            if let currentUser = userDataRepository.currentUser {
                return SettingsComposer.compose(
                    authenticationService: authenticationService,
                    user: currentUser,
                    userDataRepository: userDataRepository,
                    usernameManager: usernameManager
                )
            } else {
                return nil
            }
        }
}
