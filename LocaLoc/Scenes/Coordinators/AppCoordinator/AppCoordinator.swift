//
//  AppCoordinator.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

@Observable final class AppCoordinator {
    private let userDataRepository: UserDataRepository
    private let authenticationService: AuthenticationService

    init(userDataRepository: UserDataRepository) {
        self.authenticationService = AuthenticationService(userDataRepository: userDataRepository)
        self.userDataRepository = userDataRepository
    }

    @ViewBuilder
    func view() -> some View {
        switch userDataRepository.userAuthenticationStatus {
        case .unauthorized:
            AuthenticationView(viewModel: AuthenticationViewModel(authenticationService: authenticationService))
        case .authorized:
            HomeComposer.view(authenticationService: authenticationService, userDataRepository: userDataRepository)
        }
    }
}
