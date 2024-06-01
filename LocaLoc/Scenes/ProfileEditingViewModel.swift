//
//  ProfileEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI

@Observable final class ProfileEditingViewModel {
    var profile: Profile
    
    // MARK: - Init
    init(userDataRepository: UserDataRepository) {
        let emptyModel = Profile(firstName: "", lastName: "", email: "", imageUrl: "", username: "")
        self.profile = userDataRepository.currentUser?.profile ?? emptyModel
    }
    
    func isUserNameFree() async -> Bool {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return false
    }
}
