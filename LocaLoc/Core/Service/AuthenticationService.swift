//
//  AuthenticationService.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

enum AuthServiceError: Error {
    case googleIdTokenIsNil
}

final class AuthenticationService: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    private let dataRepository: DataRepository
    
    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
    
    func signIn(providerType: AuthenticationProviderType, view: any View) async throws {
        switch providerType {
        case .google:
            try await googleSignIn(view: view)
        case .apple:
            break
        }
    }
    
    func signOut() {
        guard let providerType = dataRepository.user.authenticationProviderType else {
            return
        }
        
        switch providerType {
        case .google:
            googleSignOut()
        case .apple:
            break
        }
    }
    
    @MainActor private func googleSignIn(view: any View) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        let rootViewController = view.rootViewController()
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        
        let accessToken = signInResult.user.accessToken
        
        guard let idToken = signInResult.user.idToken else {
            throw AuthServiceError.googleIdTokenIsNil
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: accessToken.tokenString
        )
        
        let firebaseSignInResult = try await Auth.auth().signIn(with: credential)
        
        updateUserModel(
            firstName: (firebaseSignInResult.additionalUserInfo?.profile?["given_name"] as? String) ?? "",
            lastName: (firebaseSignInResult.additionalUserInfo?.profile?["family_name"] as? String) ?? "",
            email: firebaseSignInResult.user.email ?? "",
            imageUrl: firebaseSignInResult.user.photoURL?.absoluteString ?? "",
            providerType: .google
        )
    }
    
    private func updateUserModel(
        firstName: String,
        lastName: String,
        email: String,
        imageUrl: String?,
        providerType: AuthenticationProviderType
    ) {
        let profile = Profile(
            firstName: firstName,
            lastName: lastName,
            email: email,
            imageUrl: imageUrl ?? ""
        )
        
        dataRepository.userAuthenticationStatus = .authorized
        
        dataRepository.user.authenticationStatus = .authorized
        dataRepository.user.authenticationProviderType = providerType
        dataRepository.user.profile = profile
    }
    
    private func clearUser() {
        dataRepository.user.profile = nil
        dataRepository.userAuthenticationStatus = .unauthorized
        dataRepository.user.authenticationStatus = .unauthorized
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        clearUser()
    }
}
