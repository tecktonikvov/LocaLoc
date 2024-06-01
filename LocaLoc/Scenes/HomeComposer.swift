//
//  HomeComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class HomeComposer: SceneComposer {
    @ViewBuilder static func view(authenticationService: AuthenticationService, userDataRepository: UserDataRepository) -> some View {
        let channelsScene = ChannelsComposer.compose()
        let settingsScene = settingsScene(userDataRepository: userDataRepository, authenticationService: authenticationService)

        let scenes = [channelsScene, settingsScene].compactMap { $0 }
        let model = HomeModel(tabScenes: scenes)
        
        let viewModel = HomeViewModel(model: model)
        
        HomeView()
            .environmentObject(viewModel)
    }
    
    private static func settingsScene(userDataRepository: UserDataRepository, authenticationService: AuthenticationService) -> TabScene<AnyView>? {
        if let currentUser = userDataRepository.currentUser {
            return SettingsComposer.compose(
                authenticationService: authenticationService,
                user: currentUser,
                userDataRepository: userDataRepository
            )
        } else {
            return nil
        }
    }
}
