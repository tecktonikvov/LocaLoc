//
//  AppleAuthenticationProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/5/24.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth

final class AppleAuthenticationProvider: NSObject {
    private var currentNonce: String?
    
    var completion: ((Result<AuthorizationUserData, Error>) -> Void)?
    
    // MARK: - Private
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    // MARK: - Public
    func signIn(view: any View) {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
       // authorizationController.presentationContextProvider = presenter as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
}

extension AppleAuthenticationProvider: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion?(.failure(CustomError(title: "Apple authorization", description: "Apple identity token getting error")))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion?(.failure(CustomError(title: "Apple authorization", description: "Apple id token getting error")))
                return
            }
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            
            // Sign in with Firebase.
            Task {
                do {
                    try await Auth.auth().signIn(with: credential)
                    
                    let profile = Profile(
                        firstName: "",
                        lastName: "",
                        email: "",
                        imageUrl: "",
                        username: ""
                    )
                    
                    let user = User(id: "ID", authenticationProviderType: .apple, profile: profile)
                    
                    let data = AuthorizationUserData(isNewUser: true, user: user)
                    
                    completion?(.success(data))
                } catch {
                    completion?(.failure(CustomError(title: "Apple authorization", description: "Authorization requset error")))
                    print("🔴", error)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
}
