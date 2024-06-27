//
//  KeychainDataStore+TokenSecureStorage.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import Foundation

extension KeychainDataStore: TokenSecureStorage {
    func saveToken(_ token: String) {
        let data = token.data(using: .utf8) ?? Data()
        save(data: data, forKey: "token")
    }
    
    func clearToken() {
        clearData(forKey: "token")
    }
    
    func token() -> String? {
        guard let data = loadData(forKey: "token") else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
