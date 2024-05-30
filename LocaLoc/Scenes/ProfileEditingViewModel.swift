//
//  ProfileEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI

class ProfileEditingViewModel: ObservableObject {
    var profile: Profile
    
    // MARK: - Init
    init(dataRepository: DataRepository) {
        self.profile = dataRepository.user.profile ?? Profile(firstName: "", lastName: "", email: "", imageUrl: "", username: "")
    }
    
    func isUserNameFree() async -> Bool {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return false
    }
}
