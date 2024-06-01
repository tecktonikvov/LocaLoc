//
//  UserDataRepositoryImpl+UserDataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import LocaLocDataRepository

extension UserDataRepositoryImpl: UserDataRepository {
    var currentUser: User? {
        User(repositoryUserModel: _currentUser)
    }
    
    var userAuthenticationStatus: UserAuthenticationStatus {
        isUserAuthorized ? .authorized : .unauthorized
    }
    
    func setAuthorizedUser(_ user: User) {
        setAuthorizedUser(UserPersistencyModel(user: user))
    }
}

// MARK: - Models bridges
fileprivate extension User {
    convenience init?(repositoryUserModel: UserPersistencyModel?) {
        guard let repositoryUserModel else { return nil }
        
        self.init(
            id: repositoryUserModel.id,
            authenticationProviderType: AuthenticationProviderType(repositoryTypeModel: repositoryUserModel.authenticationProviderType),
            profile: Profile(repositoryProfileModel: repositoryUserModel.profile)
        )
    }
}

fileprivate extension UserPersistencyModel {
    convenience init(user: User) {
        self.init(
            id: user.id,
            authenticationProviderType: AuthenticationProviderTypePersistencyModel(type: user.authenticationProviderType),
            profile: ProfilePersistencyModel(profile: user.profile)
        )
    }
}

fileprivate extension Profile {
    convenience init(repositoryProfileModel: ProfilePersistencyModel) {
        self.init(
            firstName: repositoryProfileModel.firstName,
            lastName: repositoryProfileModel.lastName,
            email: repositoryProfileModel.email,
            imageUrl: repositoryProfileModel.imageUrl,
            username: repositoryProfileModel.username
        )
    }
}

fileprivate extension ProfilePersistencyModel {
    convenience init(profile: Profile) {
        self.init(
            firstName: profile.firstName,
            lastName: profile.lastName,
            email: profile.email,
            imageUrl: profile.imageUrl,
            username: profile.username
        )
    }
}

fileprivate extension AuthenticationProviderType {
    init?(repositoryTypeModel: AuthenticationProviderTypePersistencyModel?) {
        guard let repositoryTypeModel else {
            return nil
        }
        
        switch repositoryTypeModel {
        case .google:
            self = .google
        case .apple:
            self = .apple
        }
    }
}

fileprivate extension AuthenticationProviderTypePersistencyModel {
    init?(type: AuthenticationProviderType?) {
        guard let type else {
            return nil
        }
        
        switch type {
        case .google:
            self = .google
        case .apple:
            self = .apple
        }
    }
}
