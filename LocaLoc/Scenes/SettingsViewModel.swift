//
//  SettingsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import Factory

@Observable class SettingsViewModel {
    var user: User
    
    @ObservationIgnored
    @Injected(\.authenticationService) private var authenticationService
    @ObservationIgnored
    @Injected(\.usernameManager) private var usernameManager
    @ObservationIgnored
    @Injected(\.userDataRepository) private var userDataRepository
    
    let profileEditingViewModel = ProfileEditingViewModel()
    
    // MARK: - Init
    init(user: User) {
        self.user = user
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
