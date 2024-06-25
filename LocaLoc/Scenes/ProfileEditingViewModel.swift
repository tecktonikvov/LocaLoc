//
//  ProfileEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI

@Observable final class ProfileEditingViewModel {
    private let usernameManager: UsernameManager
    private let userDataRepository: UserDataRepository
    
    var profile: Profile
    var errorText: String?
    var isLoading: Bool = false
    var dismiss: Bool = false
    
    private var saveRequest: Task<(), Never>?
        
    // MARK: - Init
    init(userDataRepository: UserDataRepository, usernameManager: UsernameManager) {
        self.usernameManager = usernameManager
        self.userDataRepository = userDataRepository

        let emptyModel = Profile(firstName: "", lastName: "", email: "", imageUrl: "", username: "")
        let profile = userDataRepository.currentUser?.profile ?? emptyModel
        
        self.profile = profile
    }
    
    // MARK: - Private
    private func setInitialData() {
        guard let profile = userDataRepository.currentUser?.profile else { return }
        self.profile = profile
        self.errorText = nil
        self.isLoading = false
    }
    
    private func validateUsername() async -> UsernameValidationResult {
        if profile.username.count < Constants.usernameCharactersMin {
            return .tooShort
        } else {
            do {
                let isFree = try await usernameManager.isUsernameFree(profile.username)
                
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
    
    private func saveUser() throws {
        guard let user = userDataRepository.currentUser else { return }
        user.profile = profile
        
        try userDataRepository.updateCurrentUser(user)
    }
    
    // MARK: - Public
    func saveChanges() {
        saveRequest?.cancel()
        
        isLoading = true
        
        saveRequest = Task {
            let usernameValidationResult = await validateUsername()
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                switch usernameValidationResult {
                case .requestError(let error):
                    errorText = "Something wrong"
                    // TODO: Pass to error presenter
                case .tooShort:
                    errorText = "Should be more than \(Constants.usernameCharactersMin) symbols"
                case .alreadyExist:
                    errorText = "Already exist"
                case .ok:
                    errorText = nil
                    
                    do {
                        try saveUser()
                        dismiss = true
                    } catch {
                        print(error)
                        // TODO: Pass to error presenter
                    }
                }
                
                isLoading = false
            }
        }
    }
        
    func onDisappear() {
        setInitialData()
        
        saveRequest?.cancel()
        saveRequest = nil
    }
}
