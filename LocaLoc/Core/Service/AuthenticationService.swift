//
//  AuthenticationService.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import AuthenticationServices

enum AuthServiceError: Error {
    case googleIdTokenIsNil
}

final class AuthenticationService: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    private let dataRepository: DataRepository
    
    private lazy var googleProvider: AuthenticationProvider = GoogleAuthenticationProvider()
    
    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
    
    func signIn(providerType: AuthenticationProviderType, view: any View) async throws {
        switch providerType {
        case .google:
            let profile = try await googleProvider.signIn(view: view)
            updateUserData(profile: profile, providerType: .google)
        case .apple:
            break
        }
    }
    
    func signOut() {
        if let providerType = dataRepository.user.authenticationProviderType {
            switch providerType {
            case .google:
                googleProvider.signOut()
            case .apple:
                break
            }
        }
        
        clearUser()
        dataRepository.userAuthenticationStatus = .unauthorized
    }
    
    private func updateUserData(profile: Profile, providerType: AuthenticationProviderType) {
        dataRepository.userAuthenticationStatus = .authorized
        dataRepository.user.authenticationProviderType = providerType
        dataRepository.user.profile = profile
    }
    
    private func clearUser() {
        dataRepository.user.profile = nil
    }
}
