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
        Task { @MainActor in
            do {
                try await authenticationService.signIn(providerType: providerType, view: view)
            } catch {
                Log.error("Sign in failed, provider: \(providerType) error: \(error)", module: #file)
            }
        }
    }
}
