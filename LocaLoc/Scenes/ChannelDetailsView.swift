//
//  ChannelDetailsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import SwiftUI
import PopupView

struct ChannelDetailsView: View {
    @Bindable private var viewModel: ChannelDetailsViewModel
    
    @Binding private var path: NavigationPath
    
    @State private var isDeleteButtonLoading = false
    @State private var isLeaveButtonLoading = false
    @State private var isInviteButtonLoading = false

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
                    .frame(width: 160.0, height: 160.0)
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
            .padding(.top)
            .padding(.horizontal)
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
        .popup(isPresented: $viewModel.showDeleteConfirmationPopUp) {
            deletingConfirmationView()
        } customize: {
            $0
                .appearFrom(.centerScale)
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(Color.black.opacity(0.5))
                .animation(.bouncy(duration: 0.2))
        }
        
        .popup(isPresented: $viewModel.showLeaveConfirmationPopUp) {
            leaveConfirmationView()
        } customize: {
             $0
                .appearFrom(.centerScale)
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(Color.black.opacity(0.5))
                .animation(.bouncy(duration: 0.2))
        }
    }
    
    func showShareSheet(url: URL) {
        ShareSheetPresenter.show(
            withType: .url(url),
            title: "Invitation link",
            subtitle: "Share invitation link",
            previewImage: UIImage(named: "share_sheet_icon")
        )
    }
    
    // MARK: - Private
    @ViewBuilder
    private func shareLinkButton(shareItem: ShareItem, isInvite: Bool) -> some View {
        var shareItem = shareItem
        
        if isInvite {
            Button {
                Task { @MainActor in
                    isInviteButtonLoading = true
                    
                    do {
                        let invitation = try await viewModel.createInvitation()
                        showShareSheet(url: invitation.link)
                    } catch {
                        print("🔴", error)
                    }
                    
                    isInviteButtonLoading = false
                }
            } label: {
                HStack {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 22))
                    Text("Invite")
                        .font(.system(size: 18))
                        .foregroundColor(Color.Text.main)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.01)
                    Spacer()
                    
                    if isInviteButtonLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
                .padding(4)
                .disabled(isInviteButtonLoading)
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
            } else if viewModel.channelModel.isSubscribed {
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
    }
    
    @ViewBuilder
    private func deletingConfirmationView() -> some View {
        VStack(spacing: 16) {
            Text("Delete Channel")
                .font(.title)
            
            Text("Are you sure you want to delete this channel?\nThis action cannot be undone.")
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button {
                    Task { @MainActor in
                        isDeleteButtonLoading = true

                        do {
                            try await viewModel.deleteChannel()
                            viewModel.showDeleteConfirmationPopUp = false
                            path.popToRoot()
                        }
                        
                        isDeleteButtonLoading = false
                    }
                } label: {
                    Spacer()
                    if isDeleteButtonLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("Delete")
                            .foregroundColor(Color.Text.attention)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.Extra.isabelline)
                )
                
                Button {
                    viewModel.deleteChannelCanceled()
                } label: {
                    Spacer()
                    Text("Cancel")
                        .foregroundColor(Color.Extra.taupe)
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.brand)
                )
            }
            .padding(.bottom)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.background)
        )
        .padding(.horizontal)
        .disabled(isDeleteButtonLoading)
    }
    
    @ViewBuilder
    private func leaveConfirmationView() -> some View {
        VStack(spacing: 16) {
            Text("Leave from channel")
                .font(.title)
            
            Text("Are you sure you want to leave this channel?")
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button {
                    Task { @MainActor in
                        isLeaveButtonLoading = true

                        do {
                            try await viewModel.leaveChannel()
                            viewModel.showLeaveConfirmationPopUp = false
                            path.popToRoot()
                        }
                        
                        isLeaveButtonLoading = false
                    }
                } label: {
                    Spacer()
                    if isLeaveButtonLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("Leave")
                            .foregroundColor(Color.Text.attention)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.Extra.isabelline)
                )
                
                Button {
                    viewModel.leaveChannelCanceled()
                } label: {
                    Spacer()
                    Text("Stay")
                        .foregroundColor(Color.Extra.taupe)
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.brand)
                )
            }
            .padding(.bottom)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.background)
        )
        .padding(.horizontal)
        .disabled(isLeaveButtonLoading)
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
