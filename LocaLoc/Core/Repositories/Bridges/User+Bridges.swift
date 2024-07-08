//
//  User+Bridges.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 8/7/24.
//

import LocaLocClient
import LocaLocLocalStore

// MARK: UserClientModel+UserPersistencyModel
extension UserClientModel {
    init(userLocalStoreModel: UserPersistencyModel) {
        self.init(
            id: userLocalStoreModel.id,
            authenticationProviderType: userLocalStoreModel.authenticationProviderType?.rawValue ?? "undefined",
            firstName: userLocalStoreModel.profile.firstName,
            lastName: userLocalStoreModel.profile.lastName,
            email: userLocalStoreModel.profile.email,
            imageUrl: userLocalStoreModel.profile.imageUrl,
            username: userLocalStoreModel.profile.username,
            createdAt: userLocalStoreModel.createdAt,
            updatedAt: userLocalStoreModel.updatedAt
        )
    }
    
    init(userModel: User) {
        self.init(
            id: userModel.id,
            authenticationProviderType: userModel.authenticationProviderType?.rawValue ?? "undefined",
            firstName: userModel.profile.firstName,
            lastName: userModel.profile.lastName,
            email: userModel.profile.email,
            imageUrl: userModel.profile.imageUrl,
            username: userModel.profile.username,
            createdAt: userModel.createdAt,
            updatedAt: userModel.updatedAt
        )
    }
}

// MARK: UserPersistencyModel+UserClientModel
extension UserPersistencyModel {
    convenience init(userClientModel: UserClientModel) {
        let authenticationProviderType = AuthenticationProviderTypePersistencyModel(
            rawValue: userClientModel.authenticationProviderType
        )
        
        let profile = ProfilePersistencyModel(
            firstName: userClientModel.firstName,
            lastName: userClientModel.lastName,
            email: userClientModel.email,
            imageUrl: userClientModel.imageUrl,
            username: userClientModel.username
        )
        
        self.init(
            id: userClientModel.id,
            authenticationProviderType: authenticationProviderType,
            profile: profile,
            createdAt: userClientModel.createdAt,
            updatedAt: userClientModel.updatedAt
        )
    }
}

// MARK: - Models bridges
extension User {
    convenience init(userLocalStoreModel: UserPersistencyModel) {
        let authenticationProviderType = AuthenticationProviderType(
            authenticationProviderTypeLocalStoreModel: userLocalStoreModel.authenticationProviderType
        )
        
        let profile = Profile(profileLocalStoreModel: userLocalStoreModel.profile)
        
        self.init(
            id: userLocalStoreModel.id,
            authenticationProviderType: authenticationProviderType,
            profile: profile,
            createdAt: userLocalStoreModel.createdAt,
            updatedAt: userLocalStoreModel.updatedAt
        )
    }
    
    convenience init(userClientModel: UserClientModel) {
        let authenticationProviderType = AuthenticationProviderType(
            rawValue: userClientModel.authenticationProviderType
        )
        
        let profile = Profile(userClientModel: userClientModel)
        
        self.init(
            id: userClientModel.id,
            authenticationProviderType: authenticationProviderType,
            profile: profile,
            createdAt: userClientModel.createdAt,
            updatedAt: userClientModel.updatedAt
        )
    }
}

extension UserPersistencyModel {
    convenience init(user: User) {
        let authenticationProviderType = AuthenticationProviderTypePersistencyModel(
            authenticationProviderTypeModel: user.authenticationProviderType
        )
        
        let profile = ProfilePersistencyModel(profileModel: user.profile)
        
        self.init(
            id: user.id,
            authenticationProviderType: authenticationProviderType,
            profile: profile,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt
        )
    }
}

extension Profile {
    convenience init(profileLocalStoreModel: ProfilePersistencyModel) {
        self.init(
            firstName: profileLocalStoreModel.firstName,
            lastName: profileLocalStoreModel.lastName,
            email: profileLocalStoreModel.email,
            imageUrl: profileLocalStoreModel.imageUrl,
            username: profileLocalStoreModel.username
        )
    }
    
    convenience init(userClientModel: UserClientModel) {
        self.init(
            firstName: userClientModel.firstName,
            lastName: userClientModel.lastName,
            email: userClientModel.email,
            imageUrl: userClientModel.imageUrl,
            username: userClientModel.username
        )
    }
}

extension ProfilePersistencyModel {
    convenience init(profileModel: Profile) {
        self.init(
            firstName: profileModel.firstName,
            lastName: profileModel.lastName,
            email: profileModel.email,
            imageUrl: profileModel.imageUrl,
            username: profileModel.username
        )
    }
}

extension AuthenticationProviderType {
    init?(authenticationProviderTypeLocalStoreModel: AuthenticationProviderTypePersistencyModel?) {
        guard let authenticationProviderTypeLocalStoreModel else {
            return nil
        }
        
        switch authenticationProviderTypeLocalStoreModel {
        case .google:
            self = .google
        case .apple:
            self = .apple
        }
    }
}

extension AuthenticationProviderTypePersistencyModel {
    init?(authenticationProviderTypeModel: AuthenticationProviderType?) {
        guard let authenticationProviderTypeModel else {
            return nil
        }
        
        switch authenticationProviderTypeModel {
        case .google:
            self = .google
        case .apple:
            self = .apple
        }
    }
}
