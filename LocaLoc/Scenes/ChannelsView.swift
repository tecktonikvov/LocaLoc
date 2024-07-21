//
//  ChannelsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import K_Logger

struct ChannelsView: View {
    private var viewModel: ChannelsViewModel
    
    @Binding private var path: NavigationPath
    @State private var isLoaded = false
    
    // MARK: - Init
    init(viewModel: ChannelsViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
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
                            Log.user("User selected channel with id: \(channel.id)")
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
                    Log.user("User selected create channel")
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
        .onAppear {
            viewModel.synchronizeUserChannelsList(showLoadingIndicator: !isLoaded)
            isLoaded = true
        }
    }
}

//#Preview {
//    let helper = Previewer()
//    return ChannelsView(viewModel: ChannelsViewModel(userDataRepository: helper.userDataRepository))
//}
