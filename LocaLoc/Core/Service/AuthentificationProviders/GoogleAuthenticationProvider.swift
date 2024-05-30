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

final class GoogleAuthenticationProvider: AuthenticationProvider {
    @MainActor func signIn(view: any View) async throws -> Profile {
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
            throw AuthServiceError.googleIdTokenIsNil
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: accessToken.tokenString
        )
        
        let firebaseSignInResult = try await Auth.auth().signIn(with: credential)
        
        
        return Profile(
            firstName: (firebaseSignInResult.additionalUserInfo?.profile?["given_name"] as? String) ?? "",
            lastName: (firebaseSignInResult.additionalUserInfo?.profile?["family_name"] as? String) ?? "",
            email: firebaseSignInResult.user.email ?? "",
            imageUrl: firebaseSignInResult.user.photoURL?.absoluteString ?? "",
            username: ""
        )
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
