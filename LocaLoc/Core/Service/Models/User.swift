//
//  User.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Foundation

class User: ObservableObject {
    @Published var profile: Profile? {
        didSet {
            if let encoded = try? JSONEncoder().encode(profile) {
                UserDefaults.standard.set(encoded, forKey: "user_profile")
            } else {
                UserDefaults.standard.removeObject(forKey: "user_profile")
            }
        }
    }
    
    @Published var authenticationStatus: UserAuthenticationStatus {
        didSet {
            UserDefaults.standard.setValue(authenticationStatus.rawValue, forKey: "authentication_status")
        }
    }
    
    var authenticationProviderType: AuthenticationProviderType? {
        didSet {
            if let authenticationProviderType {
                UserDefaults.standard.setValue(authenticationProviderType.rawValue, forKey: "authentication_provider_type")
            } else {
                UserDefaults.standard.removeObject(forKey: "authentication_provider_type")
            }
        }
    }
    
    init() {
        if let profile = UserDefaults.standard.data(forKey: "user_profile"),
           let decoded = try? JSONDecoder().decode(Profile.self, from: profile) {
            self.profile = decoded
        }
        
        if let authenticationStatusString = UserDefaults.standard.string(forKey: "authentication_status"),
           let authenticationStatus = UserAuthenticationStatus(rawValue: authenticationStatusString) {
            self.authenticationStatus = authenticationStatus
        } else {
            self.authenticationStatus = .unauthorized
        }
        
        if let authenticationProviderTypeString = UserDefaults.standard.string(forKey: "authentication_provider_type"),
           let authenticationProviderType = AuthenticationProviderType(rawValue: authenticationProviderTypeString) {
            self.authenticationProviderType = authenticationProviderType
        }
    }
}
