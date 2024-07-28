//
//  SettingsView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    @Binding private var path: NavigationPath
    
    // MARK: - Init
    init(viewModel: SettingsViewModel, path: Binding<NavigationPath>) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
            List {
                Section {
                    Button {
                        path.append(NavigationState.profileEditing)
                    } label: {
                        HStack(alignment: .center) {
                            let url = URL(string: viewModel.user.profile.imageUrl) ?? URL(fileURLWithPath: "")
                            let placeholder = Image(systemName: "person.circle.fill")
                            
                            CachedCenteredImage(type: .url(url, placeholder))
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            
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
                            .font(.system(size: 18))
                            .foregroundStyle(Color.Text.attention)
                            .padding(.vertical, 6)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
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
