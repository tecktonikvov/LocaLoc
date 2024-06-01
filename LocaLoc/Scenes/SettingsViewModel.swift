//
//  SettingsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

@Observable class SettingsViewModel {
    var user: User
    
    private let authenticationService: AuthenticationService
        
    // MARK: - Init
    init(user: User, authenticationService: AuthenticationService) {
        self.user = user
        self.authenticationService = authenticationService
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
