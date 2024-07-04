//
//  HomeComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import Factory

final class HomeComposer: SceneComposer {
    @ViewBuilder static func view(userDataRepository: UserDataRepository) -> some View {
            let channelsScene = ChannelsComposer.compose()
            let settingsScene = settingsScene(userDataRepository: userDataRepository)
            
            let scenes = [channelsScene, settingsScene].compactMap { $0 }
            let model = HomeModel(tabScenes: scenes)
            
            let viewModel = HomeViewModel(model: model)
            
            HomeView(viewModel: viewModel)
        }
    
    private static func settingsScene(userDataRepository: UserDataRepository) -> TabScene<AnyView>? {
        if let currentUser = userDataRepository.currentUser {
            return SettingsComposer.compose(user: currentUser)
        } else {
            return nil
        }
    }
}
