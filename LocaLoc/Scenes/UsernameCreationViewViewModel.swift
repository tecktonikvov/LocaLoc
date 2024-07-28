//
//  UsernameCreationViewViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import Foundation
import K_Logger
import Factory
import SwiftUI

enum UsernameValidationResult {
    case requestError(Error)
    case tooShort
    case alreadyExist
    case ok
}

@Observable final class UsernameCreationViewViewModel {
    @ObservationIgnored
    @Injected(\.usernameManager) private var usernameManager
    
    var username = ""
    var errorText: LocalizedStringKey?
    var isLoading: Bool = false
    
    // MARK: - Private
    private func validateUsername() async -> UsernameValidationResult {
        if username.count < Constants.usernameCharactersMin {
            return .tooShort
        } else {
            do {
                let isFree = try await usernameManager.isUsernameFree(username)
                
                if isFree {
                    return .ok
                } else {
                    return .alreadyExist
                }
            } catch {
                // TODO: Pass to error presenter
                return .requestError(error)
            }
        }
    }
    
    private func sendUsername() {
        Task {
            do {
                try await usernameManager.setUserName(username.lowercased())
            } catch {
                Log.error("Username set request error: \(error)", module: "UsernameCreationViewViewModel")
                // TODO: Pass to error presenter
            }
        }
    }
    
    // MARK: - Public
    func setUsername() {
        isLoading = true
        
        Task { @MainActor in
            let validationResult = await validateUsername()
            
            switch validationResult {
            case .requestError(let error):
                errorText = "Something wrong"
                // TODO: Pass to error presenter
            case .tooShort:
                errorText = "Should be more than \(Constants.usernameCharactersMin) symbols"
            case .alreadyExist:
                errorText = "Already exist"
            case .ok:
                errorText = nil
                sendUsername()
            }
            
            isLoading = false
        }
    }
}
