//
//  GoogleAuthenticationProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

fileprivate typealias Error = AuthenticationServiceError

final class GoogleAuthenticationProvider: AuthenticationProvider {
    @MainActor func signIn(view: any View) async throws -> AuthorizationUserData {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthenticationProviderError.firebaseClientIdIsMissed
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        let rootViewController = view.rootViewController()
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        
        let accessToken = signInResult.user.accessToken
        
        guard let idToken = signInResult.user.idToken else {
            throw Error.googleIdTokenIsNil
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: accessToken.tokenString
        )
        
        let firebaseSignInResult = try await Auth.auth().signIn(with: credential)
        
        guard let userID = Auth.auth().currentUser?.uid else {
            throw Error.userIdIsNil
        }
        
        let profile = Profile(
            firstName: (firebaseSignInResult.additionalUserInfo?.profile?["given_name"] as? String) ?? "",
            lastName: (firebaseSignInResult.additionalUserInfo?.profile?["family_name"] as? String) ?? "",
            email: firebaseSignInResult.user.email ?? "",
            imageUrl: firebaseSignInResult.user.photoURL?.absoluteString ?? "",
            username: ""
        )
        
        let user = User(id: userID, authenticationProviderType: .google, profile: profile)
        let isNewUser = (firebaseSignInResult.additionalUserInfo?.isNewUser as? Bool) ?? true
        let data = AuthorizationUserData(isNewUser: isNewUser, user: user)
        
        return data
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
