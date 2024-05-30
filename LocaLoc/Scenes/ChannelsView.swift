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
    @EnvironmentObject var viewModel: ChannelsViewModel
    
    @State private var path = NavigationPath()
    @State private var selectedChanels: [Channel] = []
    @State private var showCreateChannel = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                List {
                    ForEach(0..<viewModel.model.channels.count, id: \.self) { index in
                        let channel = viewModel.model.channels[index]
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
            }
            .navigationTitle("Channels")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
            }
            .background {
                Color.background
                    .ignoresSafeArea()
            }
           
        }
        .navigationDestination(for: NavigationState.self) { state in
            switch state {
            case .createNewChannel:
                ChannelCreationView(viewModel: ChannelCreationViewModel())
            }
        }
    }
}

#Preview {
    ChannelsView()
        .environmentObject(ChannelsViewModel())
}
