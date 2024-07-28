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
                        .padding(.top, 0)
                }
                
                HStack {
                    Text("\(viewModel.channelModel.participantsNumber) subscriber(s)")
                    Divider()
                        .frame(maxHeight: 20)
                    Text("\(viewModel.channelModel.pointsNumber) point(s)")
                }
                .foregroundStyle(Color.Text.subtitle)
                .padding(.top, 8)
                
                Divider()
                    .padding(.top, 8)
                
                buttons()
                    .padding(.top, 20)
                
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
    
    // MARK: - Private
    @ViewBuilder
    private func shareLinkButton(shareItem: ShareItem, isInvite: Bool) -> some View {
        var shareItem = shareItem
        
        if isInvite {
            ShareLink(item: shareItem.link,
                      preview: shareItem.sharePreview) {
                HStack {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 22))
                    Text("Invite")
                        .font(.system(size: 18))
                        .foregroundColor(Color.Text.main)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.01)
                    Spacer()
                }
                .padding(4)
            }
        } else {
            ShareLink(item: shareItem.link,
                      preview: shareItem.sharePreview) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 22))
                    Text("Share")
                        .font(.system(size: 18))
                        .foregroundColor(Color.Text.main)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.01)
                    Spacer()
                }
                .padding(4)
            }
        }
    }
    
    @ViewBuilder
    private func buttons() -> some View {
        VStack(spacing: 16) {
            // Share or invite button
            if let shareItemType = viewModel.shareItemType {
                switch shareItemType {
                case .free(let shareItem):
                    shareLinkButton(shareItem: shareItem, isInvite: false)
                case .invitation(let shareItem):
                    shareLinkButton(shareItem: shareItem, isInvite: true)
                }
            }
            
            // Edit button
            if viewModel.channelModel.isChannelOwner {
                BottomButton(
                    systemImage: "pencil",
                    text: "Edit",
                    foregroundColor: Color.Text.main
                ) {
                    path.append(NavigationState.channelEditing(channel: viewModel.channelModel.channel))
                }
            }
            Spacer()
            
            // Leave button
            if viewModel.channelModel.isChannelOwner {
                BottomButton(
                    systemImage: "trash",
                    text: "Delete and leave",
                    foregroundColor: Color.Text.attention
                ) {
                    viewModel.userTappedDeleteLeaveButton()
                }
            } else {
                BottomButton(
                    systemImage: "arrow.backward.square",
                    text: "Leave",
                    foregroundColor: Color.Text.attention
                ) {
                    viewModel.userTappedLeaveButton()
                }
            }
            
        }
        .foregroundColor(Color.Text.main)
        .tint(Color.background)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .padding(.horizontal)
    }
}

fileprivate struct BottomButton: View {
    let systemImage: String
    let text: LocalizedStringKey
    let foregroundColor: Color
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                Text(text)
                    .font(.system(size: 18))
                    .foregroundColor(foregroundColor)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(6)
        }
    }
}
