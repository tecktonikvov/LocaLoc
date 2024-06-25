//
//  ProfileEditingView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI
import CachedAsyncImage

struct ProfileEditingView: View {
    @Bindable private var viewModel: ProfileEditingViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showUsernameTipsView = false
    
    init(viewModel: ProfileEditingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(alignment: .center) {
                        if let url = URL(string: viewModel.profile.imageUrl) {
                            CachedAsyncImage(url: url)
                                .frame(width: 80, height: 80)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }
                        
                        VStack {
                            TextField("First name", text: $viewModel.profile.firstName.max(Constants.firstNameCharactersLimit))
                            Rectangle()
                                .frame(height: 0.5)
                            TextField("Last name", text: $viewModel.profile.lastName.max(Constants.lastNameCharactersLimit))
                        }
                        .padding(.leading)
                    }
                }
                
                VStack {
                    HStack {
                        Text("@")
                            .padding(.trailing, -6)
                        TextField("Username",
                                  text: $viewModel.profile.username.max(Constants.usernameCharactersLimit)) { isEditing in
                            showUsernameTipsView = isEditing || viewModel.errorText != nil
                        }
                    }
                    .onChange(of: viewModel.profile.username) { _, _ in
                        viewModel.errorText = nil
                    }
                    
                    if showUsernameTipsView || viewModel.errorText != nil {
                        if let errorText = viewModel.errorText {
                            Text(errorText)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.footnote)
                                .foregroundColor(Color.Text.attention)
                        } else {
                            let amount = symbolsLeft()
                            Text("\(amount) symbols left")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.footnote)
                                .foregroundColor(amount <= 0 ? Color.Text.attention : Color.Text.main)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .backgroundDefault()
        }
        .navigationTitle("Edit profile")
        .toolbar {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("Done", action: viewModel.saveChanges)
            }
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .onChange(of: viewModel.dismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .disabled(viewModel.isLoading)
    }
    
    // MARK: - Private
    private func symbolsLeft() -> Int {
        let amount = Constants.usernameCharactersLimit - viewModel.profile.username.count
        return max(0, amount)
    }
}

#Preview {
    let previewer = Previewer()
    
    return ProfileEditingView(
        viewModel: ProfileEditingViewModel(userDataRepository: previewer.userDataRepository, usernameManager: previewer.usernameManager)
    )
}
