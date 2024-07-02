//
//  ChannelsComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class ChannelsComposer: SceneComposer {
    static func compose(userDataRepository: UserDataRepository, channelsRepository: ChannelsRepository) -> TabScene<AnyView> {
        let viewModel = ChannelsViewModel(
            userDataRepository: userDataRepository,
            channelsRepository: channelsRepository
        )
        
        let view = ChannelsView(viewModel: viewModel)
        
        return TabScene(type: .channels) {
            AnyView(view)
        }
    }
}
