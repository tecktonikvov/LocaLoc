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
    @Published var userAuthenticationStatus: UserAuthenticationStatus

    private init() {
        let user = User()
        self.user = user
        self.userAuthenticationStatus = user.authenticationStatus
    }
}
