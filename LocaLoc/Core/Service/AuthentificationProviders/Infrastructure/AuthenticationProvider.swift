//
//  AuthenticationProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/5/24.
//

import SwiftUI

protocol AuthenticationProvider {
    func signIn(view: any View) async throws -> User
    func signOut()
}
