//
//  AppComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

@Observable final class AppComposer {
    private let userDataRepository: UserDataRepository
    private let authenticationService: AuthenticationService
    private let usernameManager: UsernameManager
    
    init(userDataRepository: UserDataRepository, usernameManager: UsernameManager) {
        self.authenticationService = AuthenticationService(userDataRepository: userDataRepository)
        self.userDataRepository = userDataRepository
        self.usernameManager = usernameManager
    }
    
    @ViewBuilder
    func view() -> some View {
        switch userDataRepository.userAuthenticationStatus {
        case .unauthorized:
            AuthenticationView(
                viewModel: AuthenticationViewModel(
                    authenticationService: authenticationService)
            )
        case .authorized:
            HomeComposer.view(
                authenticationService: authenticationService,
                userDataRepository: userDataRepository
            )
        case .noUsername:
            UsernameCreationView(
                viewModel: UsernameCreationViewViewModel(
                    userDataRepository: userDataRepository,
                    usernameManager: usernameManager)
            )
        }
    }
}
