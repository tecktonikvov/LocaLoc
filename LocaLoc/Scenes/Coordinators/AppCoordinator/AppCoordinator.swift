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
    
    @ObservedObject var dataRepository: DataRepository

    private var authenticationService: AuthenticationService

    init(path: NavigationPath, dataRepository: DataRepository) {
        self.path = path
        self.authenticationService = AuthenticationService(dataRepository: dataRepository)
        self.userAuthenticationStatus = dataRepository.userAuthenticationStatus
        self.dataRepository = dataRepository

        DataRepository.shared.$userAuthenticationStatus.assign(to: &$userAuthenticationStatus)
    }

    @ViewBuilder
    func view() -> some View {
        switch dataRepository.userAuthenticationStatus {
        case .unauthorized:
            AuthenticationView(viewModel: AuthenticationViewModel(authenticationService: authenticationService))
        case .authorized:
            HomeComposer.view(authenticationService: authenticationService)
        }
    }
}
