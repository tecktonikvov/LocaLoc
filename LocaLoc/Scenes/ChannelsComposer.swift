//
//  ChannelsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class ChannelsComposer: SceneComposer {
    static func compose(path: Binding<NavigationPath>) -> TabScene<AnyView> {
        let viewModel = ChannelsViewModel()
        let view = ChannelsView(viewModel: viewModel, path: path)
        
        return TabScene(type: .channels) {
            AnyView(view)
        }
    }
}
