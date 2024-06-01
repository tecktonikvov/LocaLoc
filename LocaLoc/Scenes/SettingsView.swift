//
//  SettingsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    private var userDataRepository: UserDataRepository
    
    init(viewModel: SettingsViewModel, userDataRepository: UserDataRepository) {
        self.viewModel = viewModel
        self.userDataRepository = userDataRepository
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        NavigationLink() {
                            ProfileEditingView(viewModel: ProfileEditingViewModel(userDataRepository: userDataRepository))
                        } label: {
                            HStack(alignment: .center) {
                                if let url = URL(string: viewModel.user.profile.imageUrl) {
                                    AsyncImage(url: url)
                                        .frame(width: 80, height: 80)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.user.profile.fullName)
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                        .foregroundStyle(Color.Text.main)
                                    Text("@" + (viewModel.user.profile.username))
                                        .font(.system(size: 16))
                                        .lineLimit(2)
                                        .foregroundStyle(Color.Text.main)
                                }
                                .padding()
                            }
                            .accentColor(Color.Text.main)
                        }
                    }
                    
                    Section {
                        Button {
                            viewModel.signOut()
                        } label: {
                            Text("Sign out")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.Text.attention)
                                .padding(.vertical, 6)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .background {
                Color.background
                    .ignoresSafeArea()
            }
        }
    }
}

fileprivate extension Profile {
    var fullName: String {
        firstName + " " + lastName
    }
}
//
//#Preview {
//    SettingsView(viewModel: SettingsViewModel(user: <#User#>, authenticationService: AuthenticationService(userDataRepository: .shared), userDataRepository: .shared))
//}
