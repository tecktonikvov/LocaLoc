//
//  SettingsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import LocaLocClient

@Observable class SettingsViewModel {
    var user: User
    
    private let authenticationService: AuthenticationService
    private let usernameManager: UsernameManager
    private let userDataRepository: UserDataRepository
    
    @ObservationIgnored
    lazy var profileEditingViewModel = ProfileEditingViewModel(
        userDataRepository: userDataRepository,
        usernameManager: usernameManager,
        userPhotoUploader: FilesUploadingService(userDataRepository: userDataRepository)
    )
        
    // MARK: - Init
    init(user: User,
         authenticationService: AuthenticationService,
         userDataRepository: UserDataRepository,
         usernameManager: UsernameManager) {
        self.user = user
        self.authenticationService = authenticationService
        self.userDataRepository = userDataRepository
        self.usernameManager = usernameManager
    }
    
    func signOut() {
        authenticationService.signOut()
    }
}
