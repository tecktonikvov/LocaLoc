//
//  ChannelsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct ChannelsView: View {
    @EnvironmentObject var viewModel: ChannelsViewModel
    
    @State var selectedChanels: [Channel] = []
    @State var showCreateChannel = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    NavigationLink() {
                        ChannelCreationView(viewModel: ChannelCreationViewModel())
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.Text.main)
                    }
                    .padding([.top, .trailing], 16)
                    .padding(.bottom, 8)
                }
            List() {
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
        .background {
            Color.background
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ChannelsView()
        .environmentObject(ChannelsViewModel())
}
