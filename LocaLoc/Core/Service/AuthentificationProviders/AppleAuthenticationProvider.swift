//
//  AppleAuthenticationProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/5/24.
//

import SwiftUI

final class AppleAuthenticationProvider: AuthenticationProvider {
    // TODO: Implement
    @MainActor func signIn(view: any View) async throws -> User {
        throw CustomError(title: "Not implemented", description: "Not implemented")
    }
    
    // TODO: Implement
    func signOut() {
        //...
    }
}
