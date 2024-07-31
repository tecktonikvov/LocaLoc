//
//  ChannelsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import K_Logger

struct ChannelsView: View {
    @Bindable private var viewModel: ChannelsViewModel
    
    @Binding private var path: NavigationPath

    // MARK: - Init
    init(viewModel: ChannelsViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
            VStack(alignment: .center) {
                Spacer()
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 32, height: 32)
                Text("No channels")
                Spacer()
            }
            .opacity(viewModel.channels.isEmpty ? 1 : 0)
            
            List {
                ForEach(viewModel.channels, id: \.self) { channel in
                    Button {
                        Log.user("User selected channel with id: \(channel.id)")
                        
                        Task { @MainActor in
                            if let relation = await viewModel.channelSubscriptionRelation(channelId: channel.id) {
                                path.append(NavigationState.map(channel: channel, relationType: relation))
                            }
                        }
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
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
            .opacity(viewModel.channels.isEmpty ? 0 : 1)
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
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.Text.main)
                }
            }
            
            if viewModel.showLoadingIndicator {
                ToolbarItem(placement: .topBarLeading) {
                    PointAnimationView()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .onAppear {
            viewModel.synchronizeUserChannelsList(showLoadingIndicator: true)
        }
    }
}

//#Preview {
//    let helper = Previewer()
//    return ChannelsView(viewModel: ChannelsViewModel(userDataRepository: helper.userDataRepository))
//}
