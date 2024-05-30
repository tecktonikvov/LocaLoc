//
//  SettingsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var user: User
    private let authenticationService: AuthenticationService
        
    // MARK: - Init
    init(authenticationService: AuthenticationService, dataRepository: DataRepository) {
        self.authenticationService = authenticationService
        self.user = dataRepository.user
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
