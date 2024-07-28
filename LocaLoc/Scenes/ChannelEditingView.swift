//
//  ChannelEditingView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 28/7/24.
//

import SwiftUI

struct ChannelEditingView: View {
    @State private var viewModel: ChannelEditingViewModel
    
    @Binding private var path: NavigationPath

    // MARK: - Init
    init(viewModel: ChannelEditingViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
            List {
                Section("Main information") {
                    ChannelImagePickerView(selectedImage: $viewModel.image)
                    
                    TextEditorWithPlaceholder(
                        text: $viewModel.name.max(Constants.channelNameCharactersLimit),
                        placeholder: "Name")
                    
                    TextEditorWithPlaceholder(
                        text: $viewModel.description.max(Constants.channelDescriptionCharactersLimit),
                        placeholder: "Description")
                    
                    HStack(alignment: .top) {
                        Text("@")
                            .opacity(0.6)
                        
                        LimitedTextField(
                            max: Constants.channelIdentifierMaxCharactersLimit,
                            min: Constants.channelIdentifierMinCharactersLimit,
                            title: "Identifier",
                            output: $viewModel.identifier)
                        .padding(.leading, -4)
                    }
                }
                
                Section("Settings") {
                    ChannelSettingsView(
                        selected: $viewModel.invitationMode,
                        availableInvitationModes: viewModel.availableInvitationModes
                    )
                }
            }
            .disabled(viewModel.isLoading)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.identifierErrorText),
                    message: Text("Try another one"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Edit channel")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarBackButton {
                    path.removeLast()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    let disabled = viewModel.identifier.count < Constants.channelIdentifierMinCharactersLimit
                    || viewModel.name.isEmpty
                    
                    Button("Save", action: viewModel.createChannel)
                        .disabled(disabled)
                        .foregroundColor(disabled ? Color.Text.subtitle : Color.Text.main)
                }
            }
        }
        .onChange(of: viewModel.dismiss) { _, _ in
            path.removeLast()
        }
    }
}
