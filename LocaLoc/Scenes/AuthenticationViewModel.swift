//
//  AuthenticationViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI
import K_Logger

final class AuthenticationViewModel {
    private var authenticationService: AuthenticationService

    // MARK: - Init
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    // MARK: - Public
    func signIn(providerType: AuthenticationProviderType, view: any View) {
        authenticationService.signIn(providerType: providerType, view: view) { error in
            if let error {
                Log.error("Sign in failed, provider: \(providerType) error: \(error)", module: #file)

            }
        }
    }
}
