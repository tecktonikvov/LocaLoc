//
//  UserDataRepositoryImpl+UserDataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import LocaLocDataRepository

extension UserDataRepositoryImpl: UserDataRepository {
    var currentUser: User? {
        User(persistencyUserModel: _currentUser)
    }
    
    var userAuthenticationStatus: UserAuthenticationStatus {
        isUserAuthorized ? .authorized : .unauthorized
    }
    
    func setAuthorizedUser(_ authorizationUserData: AuthorizationUserData) {
        let persistencyModel = UserPersistencyModel(user: authorizationUserData.user)
        try? setAuthorizedUser(persistencyModel, isNewUser: authorizationUserData.isNewUser)
    }
    
    func updateCurrentUser(_ user: User) {
        let persistencyModel = UserPersistencyModel(user: user)
        try? updateUserData(persistencyModel)
    }
}

// MARK: - Models bridges
fileprivate extension User {
    convenience init?(persistencyUserModel: UserPersistencyModel?) {
        guard let persistencyUserModel else { return nil }
        
        self.init(
            id: persistencyUserModel.id,
            authenticationProviderType: AuthenticationProviderType(persistencyTypeModel: persistencyUserModel.authenticationProviderType),
            profile: Profile(persistencyProfileModel: persistencyUserModel.profile)
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
    convenience init(persistencyProfileModel: ProfilePersistencyModel) {
        self.init(
            firstName: persistencyProfileModel.firstName,
            lastName: persistencyProfileModel.lastName,
            email: persistencyProfileModel.email,
            imageUrl: persistencyProfileModel.imageUrl,
            username: persistencyProfileModel.username
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
    init?(persistencyTypeModel: AuthenticationProviderTypePersistencyModel?) {
        guard let persistencyTypeModel else {
            return nil
        }
        
        switch persistencyTypeModel {
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
