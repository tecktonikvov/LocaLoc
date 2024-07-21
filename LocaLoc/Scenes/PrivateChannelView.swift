//
//  PrivateChannelView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 18/7/24.
//

import SwiftUI

struct PrivateChannelView: View {
    private var viewModel: PrivateChannelViewModel

    // MARK: - Init
    init(viewModel: PrivateChannelViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        ZStack {
            DefaultBackground()
            
            VStack(alignment: .center, spacing: 24) {
                ChannelAvatarView(url: viewModel.channelModel.channel.imageUrl)
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
                    .padding(.trailing, 8)
                
                Text(viewModel.channelModel.channel.name)
                    .font(.title)
                
                let description = viewModel.channelModel.channel.description
                
                if !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                }
                
                HStack {
                    Text("\(viewModel.channelModel.pointsNumber) points")
                    Divider()
                        .frame(maxHeight: 20)
                    Text("\(viewModel.channelModel.participantsNumber) subscribers")
                }
                .foregroundStyle(Color.Text.subtitle)
                
                Text("This is a private channel\nAsk for the invitation link from the channel owner")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
}
