//
//  AuthenticationViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI
import K_Logger
import Factory

final class AuthenticationViewModel {
    @Injected(\.authenticationService) private var authenticationService

    // MARK: - Public
    func signIn(providerType: AuthenticationProviderType, view: any View) {
        authenticationService.signIn(providerType: providerType, view: view) { error in
            if let error {
                Log.error("Sign in failed, provider: \(providerType) error: \(error)", module: #file)

            }
        }
    }
}
