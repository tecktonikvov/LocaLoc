//
//  AppComposer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI
import Factory

@Observable final class AppComposer {
    private var userDataRepository = Container.shared.userDataRepository()
    
    @ViewBuilder
    func view() -> some View {
        switch userDataRepository.userAuthenticationStatus {
        case .unauthorized:
            AuthenticationView(viewModel: AuthenticationViewModel())
        case .authorized:
            HomeComposer.view(userDataRepository: userDataRepository)
        case .noUsername:
            UsernameCreationView(viewModel: UsernameCreationViewViewModel())
        }
    }
}
