//
//  SettingsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Combine
import SwiftUI

struct SettingsModel {
    let text: String
}

class SettingsViewModel: ObservableObject {
    @Published private(set) var error: Error? = nil
    
    private let model: SettingsModel
    private let authenticationService: AuthenticationService
    
    let didNavigateBack = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(authenticationService: AuthenticationService) {
        self.model = SettingsModel(text: "Test")
        self.authenticationService = authenticationService
    }

    func backAction() {
        didNavigateBack.send(())
    }
    
    func signOut() {
        authenticationService.googleSignOut()
    }
}
