//
//  Dependencies.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 3/7/24.
//

import Factory
import K_Logger
import LocaLocClient
import LocaLocLocalStore
import LocaLocDataRepository

extension Container {
    // MARK: - Private
    private var moduleName: String {
        "Dependencies"
    }
    
    private var keychainDataStore: Factory<KeychainDataStore> {
        Factory(self) { KeychainDataStore() }
    }
    
    private var filesUploadingService: Factory<FilesUploadingService> {
        Factory(self) { FilesUploadingService(userDataRepository: self.userDataDataRepository()) }
    }
    
    private var appLocalStorage: Factory<AppLocalStorage> {
        Factory(self) {
            do {
                return try AppLocalStorage(with: UserPersistencyModel.self,
                                           ProfilePersistencyModel.self,
                                           ChannelPersistencyModel.self,
                                           ChannelUserSettingsPersistencyModel.self,
                                           ChannelSettingsPersistencyModel.self)
            } catch {
                let errorString = "LocalStorage initialization error: \(error)"
                
                Log.error(errorString, module: self.moduleName)
                fatalError(errorString)
            }
        }
        .singleton
    }
    
    private var userDataDataRepository: Factory<UserDataDataRepository> {
        Factory(self) {
            do {
                return try UserDataDataRepository(localStorage: self.appLocalStorage())
            } catch {
                let errorString = "UsernameManager initialization error: \(error)"
                
                Log.error(errorString, module: self.moduleName)
                fatalError(errorString)
            }
        }
        .singleton
    }
    
    private var channelsDataRepository: Factory<ChannelsDataRepository> {
        Factory(self) {
            do {
                return try ChannelsDataRepository(localStorage: self.appLocalStorage())
            } catch {
                let errorString = "ChannelsDataRepository initialization error: \(error)"
                
                Log.error(errorString, module: self.moduleName)
                fatalError(errorString)
            }
        }
        .singleton
    }
    
    private var channelIdentifierClient: Factory<ChannelIdentifierClient> {
        Factory(self) { ChannelIdentifierClient() }
    }
    
    // MARK: - Public
    var localStorage: Factory<LocalStorage> {
        Factory(self) { self.appLocalStorage() }
    }
    
    var usernameManager: Factory<UsernameManager> {
        Factory(self) { self.userDataDataRepository() }
    }
    
    var channelPhotoUploader: Factory<ChannelPhotoUploader> {
        Factory(self) { self.filesUploadingService() }
    }
    
    var userPhotoUploader: Factory<UserPhotoUploader> {
        Factory(self) { self.filesUploadingService() }
    }
    
    var tokenSecureStorage: Factory<TokenSecureStorage> {
        Factory(self) { self.keychainDataStore() }
    }
    
    var userDataRepository: Factory<UserDataRepository> {
        Factory(self) { self.userDataDataRepository() }
            .singleton
    }
    
    var channelsRepository: Factory<ChannelsRepository> {
        Factory(self) { self.channelsDataRepository() }
    }
    
    var channelIdentifierChecker: Factory<ChannelIdentifierChecker> {
        Factory(self) { self.channelIdentifierClient() }
    }
    
    var authenticationService: Factory<AuthenticationService> {
        Factory(self) { AuthenticationService() }
    }    
}
