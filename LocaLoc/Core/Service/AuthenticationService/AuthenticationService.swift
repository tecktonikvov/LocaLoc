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
    
    // MARK: - Init
    init(userDataRepository: UserDataRepository) {
        self.userDataRepository = userDataRepository
    }
    
    // MARK: - Private
    private func setCrashlyticsData(user: User) {
        CrashlyticsService.shared.set(userId: user.id)
        CrashlyticsService.shared.set(username: user.profile.username)
        CrashlyticsService.shared.set(userEmail: user.profile.email)
    }
    
    // MARK: - Public
    func signIn(providerType: AuthenticationProviderType, view: any View) async throws {
        switch providerType {
        case .google:
            let data = try await googleProvider.signIn(view: view)
            setCrashlyticsData(user: data.user)
            
            try userDataRepository.setAuthorizedUser(data)
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
