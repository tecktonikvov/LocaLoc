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
    
    let profileEditingViewModel = ProfileEditingViewModel()
    
    // MARK: - Init
    init(user: User) {
        self.user = user
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
