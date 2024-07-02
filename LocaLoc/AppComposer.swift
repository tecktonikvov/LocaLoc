//
//  AppComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

@Observable final class AppComposer {
    private let usernameManager: UsernameManager
    private let channelsRepository: ChannelsRepository
    private let userDataRepository: UserDataRepository
    private let authenticationService: AuthenticationService

    init(
        userDataRepository: UserDataRepository,
        usernameManager: UsernameManager,
        channelsRepository: ChannelsRepository
    ) {
        self.authenticationService = AuthenticationService(userDataRepository: userDataRepository)
        self.usernameManager = usernameManager
        self.channelsRepository = channelsRepository
        self.userDataRepository = userDataRepository
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
                userDataRepository: userDataRepository, 
                usernameManager: usernameManager, 
                channelsRepository: channelsRepository
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
