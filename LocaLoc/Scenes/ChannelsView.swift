//
//  ChannelsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

fileprivate enum NavigationState: Hashable {
    case createNewChannel
    case map(channel: Channel)
}

struct ChannelsView: View {
    var viewModel: ChannelsViewModel
    
    @State private var path = NavigationPath()
    
    @State private var isLoaded = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(gradient: Gradient(
                    colors: [.backgroundGradientTop, .backgroundGradientBottom]),
                               startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if viewModel.channelsRepository.channels.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "list.bullet")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("No channels")
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.channelsRepository.channels, id: \.self) { channel in
                            Button {
                                path.append(NavigationState.map(channel: channel))
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
                        viewModel.synchronizeUserChannelsList(showLoadingIndicator: false)
                    }
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
                
                if viewModel.showLoadingIndicator {
                    ToolbarItem(placement: .topBarLeading) {
                        PointAnimationView()
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .navigationDestination(for: NavigationState.self) { state in
                switch state {
                case .createNewChannel:
                    ChannelCreationView(viewModel: ChannelCreationViewModel())
                case .map(let channel):
                    MapContainerView(viewModel: MapContainerViewModel(channel: channel))
                }
            }
            .onAppear {
                viewModel.synchronizeUserChannelsList(showLoadingIndicator: !isLoaded)
                isLoaded = true
            }
        }
    }
}

//#Preview {
//    let helper = Previewer()
//    return ChannelsView(viewModel: ChannelsViewModel(userDataRepository: helper.userDataRepository))
//}
