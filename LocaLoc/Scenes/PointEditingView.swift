//
//  PointEditingView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 15/7/24.
//

import SwiftUI

struct PointEditingView: View {
    enum Field: Hashable {
        case address
        case description
    }
    
    @FocusState private var focusedField: Field?
    
    @State private var isEmojiPickerPresented: Bool = false
    
    @Bindable private var viewModel: PointEditingViewModel
    
    // MARK: - Init
    init(viewModel: PointEditingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Edit point")
                        .font(.title)
                    Spacer()
                    Button {
                        focusedField = nil
                        viewModel.userTappedCloseButton()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.Text.main)
                    }
                    .padding(.trailing, 4)
                }
                
                HStack {
                    Text("Point sign")
                        .font(.title3)
                    
                    Spacer()
                    
                    Button {
                        viewModel.selectedPointSingType = .default
                    } label: {
                        Image("marker_default")
                            .resizable()
                            .frame(width: 32, height: 48)
                    }
                    .padding(8)
                    .background((viewModel.selectedPointSingType == .default ? Color.gray : Color.clear))
                    .cornerRadius(8)
                    
                    Button {
                        viewModel.selectedPointSingType = .emoji
                        isEmojiPickerPresented.toggle()
                    } label: {
                        ZStack(alignment: .top) {
                            Image("marker_with_placeholder")
                                .resizable()
                                .frame(width: 32, height: 48)
                            Text(viewModel.selectedEmojiCode)
                                .font(.system(size: 32))
                        }
                    }
                    .padding(8)
                    .background((viewModel.selectedPointSingType == .emoji ? Color.gray : Color.clear))
                    .cornerRadius(8)
                    .emojiPicker(
                        isPresented: $isEmojiPickerPresented,
                        selectedEmoji: $viewModel.selectedEmojiCode
                    )
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Address")
                            .font(.title3)
                        TextField("",
                                  text: $viewModel.channelPoint.address.max(Constants.pointAdressMaxCharactersLimit),
                                  axis: .vertical)
                        .padding(8)
                        .background(Color.clear)
                        .focused($focusedField, equals: .address)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .onChange(of: viewModel.channelPoint.address) { _, newValue in
                            if newValue.contains("\n") {
                                viewModel.channelPoint.address = newValue.replacingOccurrences(of: "\n", with: "")
                                focusedField = .description
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.title3)
                        TextField("",
                                  text: $viewModel.channelPoint.description.max(Constants.pointDescriptionMaxCharactersLimit),
                                  axis: .vertical)
                        .padding(8)
                        .background(Color.clear)
                        .focused($focusedField, equals: .description)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .onChange(of: viewModel.channelPoint.description) { _, newValue in
                            if newValue.contains("\n") {
                                viewModel.channelPoint.description = newValue.replacingOccurrences(of: "\n", with: "")
                                focusedField = nil
                            }
                        }
                    }
                    
                    Toggle("Show point to users", isOn: !$viewModel.channelPoint.isHidden)
                        .tint(Color.brand)
                }
                
                HStack(spacing: 16) {
                    Button {
                        focusedField = nil
                        viewModel.deletePointTapped()
                    } label: {
                        Spacer()
                        if viewModel.isDeleteButtonLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Delete")
                                .foregroundColor(Color.Text.attention)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Button {
                        focusedField = nil
                        viewModel.updatePoint()
                    } label: {
                        Spacer()
                        if viewModel.isApproveButtonLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Save")
                                .foregroundColor(Color.Extra.taupe)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.brand)
                    )
                }
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.background)
            )
        }
        .disabled(viewModel.isApproveButtonLoading)
        .popup(isPresented: $viewModel.showDeletePointModal) {
            deletingConfirmationView()
        } customize: {
            $0
                .appearFrom(.centerScale)
                .isOpaque(true)
                .closeOnTap(false)
                .backgroundColor(Color.black.opacity(0.5))
                .animation(.bouncy(duration: 0.2))
        }
    }
    
    // MARK: - Private
    @ViewBuilder
    private func deletingConfirmationView() -> some View {
        VStack(spacing: 16) {
            Text("Delete Point")
                .font(.title)
            
            Text("Are you sure you want to delete this point?\nThis action cannot be undone.")
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button {
                    viewModel.deletePoint()
                } label: {
                    Spacer()
                    if viewModel.isDeleteButtonLoading {
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
                    viewModel.deletePointCanceled()
                } label: {
                    Spacer()
                    if viewModel.isApproveButtonLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("Cancel")
                            .foregroundColor(Color.Extra.taupe)
                    }
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
        .disabled(viewModel.isDeleteButtonLoading)
    }
}
