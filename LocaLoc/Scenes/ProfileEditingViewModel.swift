//
//  ProfileEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI

@Observable final class ProfileEditingViewModel {
    var profile: Profile
    private let userDataRepository: UserDataRepository
    
    // MARK: - Init
    init(userDataRepository: UserDataRepository) {
        self.userDataRepository = userDataRepository
        
        let emptyModel = Profile(firstName: "", lastName: "", email: "", imageUrl: "", username: "")
        self.profile = userDataRepository.currentUser?.profile ?? emptyModel
    }
    
    // MARK: - Private
    private func setInitialProfileData() {
        guard let profile = userDataRepository.currentUser?.profile else { return }
        self.profile = profile
    }
    
    // MARK: - Public
    func isUserNameFree() async -> Bool {
        //try? await Task.sleep(nanoseconds: 1_000_000_000)
        // TODO: Add veri
        return true
    }
    
    func saveChanges() {
        guard let user = userDataRepository.currentUser else { return }
        user.profile = profile
        
        userDataRepository.updateCurrentUser(user)
    }
    
    func onDisappear() {
        setInitialProfileData()
    }
}
