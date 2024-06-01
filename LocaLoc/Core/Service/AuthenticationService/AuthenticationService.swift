//
//  AuthenticationService.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import AuthenticationServices

final class AuthenticationService: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    private let userDataRepository: UserDataRepository
    
    private lazy var googleProvider: AuthenticationProvider = GoogleAuthenticationProvider()
    
    init(userDataRepository: UserDataRepository) {
        self.userDataRepository = userDataRepository
    }
    
    func signIn(providerType: AuthenticationProviderType, view: any View) async throws {
        switch providerType {
        case .google:
            let user = try await googleProvider.signIn(view: view)
            userDataRepository.setAuthorizedUser(user)
        case .apple:
            break
        }
    }
    
    func signOut() {
        if let providerType = userDataRepository.currentUser?.authenticationProviderType {
            switch providerType {
            case .google:
                googleProvider.signOut()
                userDataRepository.clearCurrentUserData()
            case .apple:
                break
            }
        }
    }
}
