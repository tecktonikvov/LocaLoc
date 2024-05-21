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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("Button was tapped")
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.ContentPrimary.Text.main)
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
                                  : UIColor.clear).animation(.easeIn)
                        )
                    
                        .frame(height: 70)
                        .onTapGesture {
                            selectedChanels.append(channel)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                selectedChanels.removeAll(where: { $0 == channel })
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            
        }
        .background {
            Color.ContentPrimary.background
                .ignoresSafeArea()
        }
      
    }
}

struct ChannelsRow: View {
    private let channel: Channel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ChannelAvatar(url: channel.imageUrl)
                .frame(width: 60.0, height: 60.0)
                .clipShape(Circle())
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(channel.title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(Color.ContentPrimary.Text.main)
                
                Text(channel.subtitle)
                    .font(.system(size: 18))
                    .lineLimit(2)
                    .foregroundStyle(Color.ContentPrimary.Text.main)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(dateFormatter.string(from: channel.lastUpdateTime))
                    .foregroundStyle(Color.ContentPrimary.Text.main)
                Spacer()
                
                if channel.missedUpdatesNumber > 0 {
                    ZStack {
                        Circle()
                            .fill(channel.isMuted
                                  ? Color.Extra.silver
                                  : Color.ContentPrimary.Text.attention)
                           
                        let text = channel.missedUpdatesNumber > 99 ? "99+" : String(channel.missedUpdatesNumber)
                        Text(text)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.Extra.taupe)
                    }
                    .frame(width: 26, height: 26)
                }
            }
        }
    }
}

struct ChannelAvatar: View {
    private let url: URL?
  
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        if let url {
            AsyncImage(url: url)
        } else {
            Image(systemName: "location.circle.fill")
                .resizable()
                .foregroundStyle(Color.Extra.battleshipGray)
        }
    }
}

#Preview {
    ChannelsView()
        .environmentObject(ChannelsViewModel())
}
