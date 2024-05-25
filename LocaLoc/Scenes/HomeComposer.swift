//
//  HomeComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class HomeComposer: SceneComposer {
    @ViewBuilder static func view(authenticationService: AuthenticationService) -> some View {
        let channelsScene = ChannelsComposer.compose()
        let settingsScene = SettingsComposer.compose(authenticationService: authenticationService)

        let model = HomeModel(tabScenes: [channelsScene, settingsScene])
        let viewModel = HomeViewModel(model: model)
        
        HomeView()
            .environmentObject(viewModel)
    }
}
