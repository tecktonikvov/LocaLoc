//
//  MainComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class MainComposer: SceneComposer {
    @ViewBuilder static func view() -> some View {
        let channelsScene = ChannelsComposer.compose()
        let settingsScene = SettingsComposer.compose()

        let model = MainModel(tabScenes: [channelsScene, settingsScene])
        let viewModel = MainViewModel(model: model)
        MainView()
            .environmentObject(viewModel)
    }
}
