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
    
    private lazy var appleProvider = AppleAuthenticationProvider()
    private lazy var googleProvider = GoogleAuthenticationProvider()

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
    func signIn(providerType: AuthenticationProviderType, view: any View, completion: @escaping (Error?) -> Void) {
        switch providerType {
        case .google:
            Task {
                do {
                    let authorizationData = try await googleProvider.signIn(view: view)
                    
                    #warning("FIX")
                    setCrashlyticsData(user: authorizationData.user)
                    
                    try userDataRepository.setAuthorizedUser(authorizationData)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
           
        case .apple:
            appleProvider.completion = { [weak self] result in
                switch result {
                case .failure(let error):
                    completion(error)
                case .success(let authorizationData):
                    do {
                        self?.setCrashlyticsData(user: authorizationData.user)
                        try self?.userDataRepository.setAuthorizedUser(authorizationData)
                    } catch {
                        completion(error)
                    }
                }
            }
            
            appleProvider.signIn(view: view)
        }
    }
    
    func signOut() {
        if let providerType = userDataRepository.currentUser?.authenticationProviderType {
            switch providerType {
            case .google:
                googleProvider.signOut()
            case .apple:
                break
            }
            
            userDataRepository.clearCurrentUserData()
        }
    }
}
