//
//  ChannelsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class ChannelsComposer: SceneComposer {
    static func compose() -> TabScene<AnyView> {
        let viewModel = ChannelsViewModel()
        let view = ChannelsView()
            .environmentObject(viewModel)
        
        return TabScene(type: .channels) {
            AnyView(view)
        }
    }
}
