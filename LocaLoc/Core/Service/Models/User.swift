//
//  User.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Foundation

class User: ObservableObject {
    private static let profileKey = UserDefaultsKeys.userProfile.rawValue
    private static let authenticationProviderTypeKey = UserDefaultsKeys.userProfile.rawValue
    
    @Published var profile: Profile? {
        didSet {
            do {
                if let profile {
                    let encoded = try JSONEncoder().encode(profile)
                    UserDefaults.standard.set(encoded, forKey: Self.profileKey)
                } else {
                    UserDefaults.standard.removeObject(forKey: Self.profileKey)
                }
            } catch {
                print("🔴", error)
            }
        }
    }
    
    var authenticationProviderType: AuthenticationProviderType? {
        didSet {
            if let authenticationProviderType {
                UserDefaults.standard.setValue(authenticationProviderType.rawValue, forKey: Self.authenticationProviderTypeKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.authenticationProviderTypeKey)
            }
        }
    }
    
    init() {
        if let profile = UserDefaults.standard.data(forKey: Self.profileKey),
           let decoded = try? JSONDecoder().decode(Profile.self, from: profile) {
            self.profile = decoded
        }
        
        if let authenticationProviderTypeString = UserDefaults.standard.string(forKey: Self.authenticationProviderTypeKey),
           let authenticationProviderType = AuthenticationProviderType(rawValue: authenticationProviderTypeString) {
            self.authenticationProviderType = authenticationProviderType
        }
    }
}
