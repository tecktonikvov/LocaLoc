//
//  AuthenticationViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import FirebaseAuth
import AuthenticationServices
import FirebaseCore
import GoogleSignIn
import SwiftUI
import Combine

final class AuthenticationViewModel: ObservableObject {
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    private var authenticationService: AuthenticationService
    
    func signIn(providerType: AuthenticationProviderType, view: any View) {
        Task { @MainActor in
            do {
                try await authenticationService.signIn(providerType: providerType, view: view)
            } catch {
                print(error)
            }
        }
    }
}
