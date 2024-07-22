//
//  ChannelDetailsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import SwiftUI

struct ChannelDetailsView: View {
    private let viewModel: ChannelDetailsViewModel
    
    @Binding private var path: NavigationPath
        
    // MARK: - Init
    init(viewModel: ChannelDetailsViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
            VStack(alignment: .center) {
                ChannelAvatarView(url: viewModel.channelModel.channel.imageUrl)
                    .frame(width: 120.0, height: 120.0)
                    .clipShape(Circle())
                    .padding(.trailing, 8)
                
                Text(viewModel.channelModel.channel.name)
                    .font(.title)
                    .padding(.top, 24)
                
                let description = viewModel.channelModel.channel.description
                if !description.isEmpty {
                    Text(description)
                        .font(.title3)
                        .foregroundStyle(Color.Text.subtitle)
                        .padding(.top, 0)
                }
                
                HStack {
                    Text("\(viewModel.channelModel.pointsNumber) points")
                    Divider()
                        .frame(maxHeight: 20)
                    Text("\(viewModel.channelModel.participantsNumber) subscribers")
                }
                .foregroundStyle(Color.Text.subtitle)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.top, 24)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarBackButton {
                    path.removeLast()
                }
            }
            
            ToolbarItem(placement: .navigation) {
                HStack {
                    Spacer()
                    Text("Details")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
        }
    }
}
