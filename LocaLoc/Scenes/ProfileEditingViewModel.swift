//
//  ProfileEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/5/24.
//

import SwiftUI
import PhotosUI

@Observable final class ProfileEditingViewModel {
    private let usernameManager: UsernameManager
    private let userDataRepository: UserDataRepository
    private let userPhotoUploader: UserPhotoUploader
    
    var profile: Profile
    var errorText: String?
    var isLoading: Bool = false
    var dismiss: Bool = false
    
    var selectedUIImage: UIImage?
    var selectedPickerImage: PhotosPickerItem?
    
    private var doesUserNameWasChanged: Bool {
        profile.username != initialUserName
    }
    
    private let initialUserName: String
    private var saveRequest: Task<(), Never>?
    
    // MARK: - Init
    init(userDataRepository: UserDataRepository, usernameManager: UsernameManager, userPhotoUploader: UserPhotoUploader) {
        self.usernameManager = usernameManager
        self.userPhotoUploader = userPhotoUploader
        self.userDataRepository = userDataRepository

        let emptyModel = Profile(firstName: "", lastName: "", email: "", imageUrl: "", username: "")
        let profile = userDataRepository.currentUser?.profile ?? emptyModel
        
        self.profile = profile
        self.initialUserName = profile.username
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
                return .requestError(error)
            }
        }
    }
    
    private func saveUser() throws {
        guard let user = userDataRepository.currentUser else { return }
        user.profile = profile
        
        try userDataRepository.updateCurrentUser(user)
    }
    
    private func uploadImage(_ image: UIImage) async throws -> URL {
        let fileUrl = try await userPhotoUploader.uploadUserPhoto(image)
        return fileUrl
    }
    
    @MainActor
    private func setErrorText(_ text: String?) {
        errorText = text
    }
    
    private func usernameError() async -> String? {
        guard doesUserNameWasChanged else {
            return nil
        }
        
        let usernameValidationResult = await validateUsername()
        
        guard !Task.isCancelled else { return nil }
        
        switch usernameValidationResult {
        case .requestError(let error):
            return ("Something wrong")
            // TODO: Pass to error presenter
        case .tooShort:
            return ("Should be more than \(Constants.usernameCharactersMin) symbols")
        case .alreadyExist:
            return ("Already exist")
        case .ok:
            return nil
        }
    }
    
    private func updateUserImage(_ image: UIImage) async throws {
        let userAvatarUrl = try await uploadImage(image)
        profile.imageUrl = userAvatarUrl.absoluteString
    }
    
    // MARK: - Public
    func saveChanges() {
        saveRequest?.cancel()
        
        isLoading = true
        
        saveRequest = Task {
            let userNameError = await usernameError()
            
            guard !Task.isCancelled else { return }
            
            guard userNameError == nil else {
                await setErrorText(userNameError!)
                return
            }
            
            do {
                if let selectedUIImage {
                    try await updateUserImage(selectedUIImage)
                }
                
                try await MainActor.run {
                    try saveUser()
                    dismiss = true
                }
            } catch {
                print("🔴Error", error)
                // TODO: Pass to error presenter
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
        
    func onDisappear() {
        setInitialData()
        
        saveRequest?.cancel()
        saveRequest = nil
    }
    
    func setSelectedUIImage() {
        Task {
            do {
                guard let selectedPickerImage else { return }
                let data = try await selectedPickerImage.loadTransferable(type: Data.self)
                selectedUIImage = UIImage(data: data ?? Data())
            } catch {
                print(error)
                // TODO: Handle error
            }
        }
    }
}
