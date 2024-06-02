//
//  ProfileEditingView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI
import CachedAsyncImage

struct ProfileEditingView: View {
    @Bindable var viewModel: ProfileEditingViewModel
    
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
                            TextField("First name", text: $viewModel.profile.firstName)
                            Rectangle()
                                .frame(height: 0.5)
                            TextField("Last name", text: $viewModel.profile.lastName)
                        }
                        .padding(.leading)
                        
                    }
                }
                
                Section() {
                    HStack {
                        Text("@")
                            .padding(.trailing, -4)
                        TextField("Username", text: $viewModel.profile.username)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .backgroundDefault()
        }
        .navigationTitle("Edit profile")
        .toolbar {
            Button("Done") {
                Task {
                    let isUserNameFree = await viewModel.isUserNameFree()
                    
                    await MainActor.run {
                        if isUserNameFree {
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let previewer = Previewer()
    
    return ProfileEditingView(
        viewModel: ProfileEditingViewModel(userDataRepository: previewer.userDataRepository)
    )
}
