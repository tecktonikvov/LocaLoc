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
    func view(path: Binding<NavigationPath>) -> some View {
        switch userDataRepository.userAuthenticationStatus {
        case .unauthorized:
            AuthenticationView(viewModel: AuthenticationViewModel())
        case .authorized:
            HomeComposer.view(userDataRepository: userDataRepository, path: path)
        case .noUsername:
            UsernameCreationView(viewModel: UsernameCreationViewViewModel())
        }
    }
}
