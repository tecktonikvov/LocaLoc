//
//  ChannelsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

fileprivate enum NavigationState {
    case createNewChannel
}

struct ChannelsView: View {
    var viewModel: ChannelsViewModel
    
    @State private var path = NavigationPath()
    @State private var selectedChanels: [Channel] = []
    @State private var animationAmount = 0.0
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                List {
                    ForEach(0..<viewModel.channelsRepository.channels.count, id: \.self) { index in
                        let channel = viewModel.channelsRepository.channels[index]
                        let isSelected = selectedChanels.first(where: { $0 == channel }) != nil
                        
                        ChannelsRow(channel: channel)
                            .listRowBackground(
                                Color(isSelected
                                      ? UIColor.lightGray
                                      : UIColor.clear).animation(.easeIn(duration: 0.1))
                            )
                        
                            .frame(height: 70)
                            .onTapGesture {
                                selectedChanels.append(channel)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    selectedChanels.removeAll(where: { $0 == channel })
                                }
                            }
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
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.Text.main)
                    }
                }
                
                if viewModel.isDataSynchronizationRunning {
                    ToolbarItem(placement: .topBarLeading) {
                        Image("point")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
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
