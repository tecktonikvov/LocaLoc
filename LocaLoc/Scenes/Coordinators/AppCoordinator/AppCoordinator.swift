//
//  AppCoordinator.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var path: NavigationPath
    @Published var userAuthenticationStatus: UserAuthenticationStatus

    private var authenticationService: AuthenticationService

    init(path: NavigationPath) {
        self.path = path
        self.authenticationService = AuthenticationService(dataRepository: DataRepository.shared)
        self.userAuthenticationStatus = DataRepository.shared.user.authenticationStatus
        
        DataRepository.shared.$userAuthenticationStatus.assign(to: &$userAuthenticationStatus)
    }

    @ViewBuilder
    func view() -> some View {
        switch userAuthenticationStatus {
        case .unauthorized:
            AuthenticationView()
                .environmentObject(AuthenticationViewModel(authenticationService: authenticationService))
        case .authorized:
            HomeComposer.view(authenticationService: authenticationService)
        }
    }
}
