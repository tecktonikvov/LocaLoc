//
//  ProfileEditingView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI

struct ProfileEditingView: View {
    @Bindable var viewModel: ProfileEditingViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(alignment: .center) {
                        if let url = URL(string: viewModel.profile.imageUrl) {
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
            .background(Color.background)
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
    do {
        let previewer = try Previewer()
        let userDataRepository = UserDataRepository(modelContext: previewer.container.mainContext)
        
        return ProfileEditingView(
            viewModel: ProfileEditingViewModel(userDataRepository: userDataRepository)
        )
    } catch {
        return Text(error.localizedDescription)
    }
}
