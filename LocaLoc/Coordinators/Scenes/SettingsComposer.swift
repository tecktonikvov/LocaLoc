//
//  SettingsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class SettingsComposer: SceneComposer {
    static func compose() -> TabScene<AnyView> {
        let viewModel = SettingsViewModel()
        let view = SettingsView()
            .environmentObject(viewModel)
        return TabScene(type: .settings) {
            AnyView(view)
        }
    }
}
