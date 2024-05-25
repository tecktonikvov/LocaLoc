//
//  DataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Foundation

final class DataRepository: ObservableObject {
    static let shared = DataRepository()
    
    @Published var user: User
    @Published var userAuthenticationStatus: UserAuthenticationStatus {
        didSet {
           UserDefaults.standard.setValue(
               userAuthenticationStatus.rawValue,
               forKey: UserDefaultsKeys.authenticationStatus.rawValue
           )
       }
   }

    private init() {
        let user = User()
        var userAuthenticationStatus: UserAuthenticationStatus {
            if let rawValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.authenticationStatus.rawValue),
               let authenticationStatus = UserAuthenticationStatus(rawValue: rawValue) {
                return authenticationStatus
            } else {
               return .unauthorized
            }
        }
        self.userAuthenticationStatus = userAuthenticationStatus
        self.user = user
    }
}
