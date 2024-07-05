//
//  ChannelsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

fileprivate enum NavigationState: Hashable {
    case createNewChannel
    case map(channelId: Channel)
}

struct ChannelsView: View {
    var viewModel: ChannelsViewModel
    
    @State private var path = NavigationPath()
    @State private var animationAmount = 0.0
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                List {
                    ForEach(0..<viewModel.channelsRepository.channels.count, id: \.self) { index in
                        let channel = viewModel.channelsRepository.channels[index]
                        
                        Button {
                            path.append(NavigationState.map(channelId: channel))
                        } label: {
                            ChannelsRow(channel: channel)
                        }
                        .frame(height: 70)
                        .listRowBackground(
                            Color(UIColor.clear)
                        )
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.synchronizeUserChannelsList()
                }
            }
            .navigationTitle("Channels")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(NavigationState.createNewChannel)
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.Text.main)
                    }
                }
                
                if viewModel.isDataSynchronizationRunning {
                    ToolbarItem(placement: .topBarLeading) {
                        Image("point")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.brand)
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                    animationAmount += 360
                                }
                            }
                    }
                }
            }
            .backgroundDefault()
            .navigationDestination(for: NavigationState.self) { state in
                switch state {
                case .createNewChannel:
                    ChannelCreationView(viewModel: viewModel.channelCreationViewModel)
                case .map(let channel):
                    MapContainerView(viewModel: MapContainerViewModel(channel: channel))
                }
            }
            .onAppear {
                viewModel.synchronizeUserChannelsList()
            }
        }
    }
}

//#Preview {
//    let helper = Previewer()
//    return ChannelsView(viewModel: ChannelsViewModel(userDataRepository: helper.userDataRepository))
//}
