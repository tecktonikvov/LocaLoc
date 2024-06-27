//
//  KeychainDataStore.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import Foundation
import Security

/// ``KeychainDataStore`` is wrapper above keychain, with friendly interface.
///
/// Not thread safe! Manage multithreading in higher level objects.
final class KeychainDataStore {
    private func save(data: Data, in query: KeychainQuery) {
        query.deleteItem()
        query.saveData(data: data)
    }

    private func clearData(in query: KeychainQuery) {
        query.deleteItem()
    }

    private func loadData(in query: KeychainQuery) -> Data? {
        query.loadData()
    }
    
    // MARK: - Init
    init() {}
    
    // MARK: - Public
    func loadData(forKey key: String) -> Data? {
        loadData(in: PasswordQuery(key: key))
    }
    
    func save(data: Data, forKey key: String) {
        save(data: data, in: PasswordQuery(key: key))
    }

    func clearData(forKey key: String) {
        clearData(in: PasswordQuery(key: key))
    }
}

// MARK: - KeychainDataStore
fileprivate extension KeychainDataStore {
    // MARK: - PasswordQuery
    struct PasswordQuery: KeychainQuery {
        let key: String

        func query(for operation: KeychainQueryOperation) -> CFDictionary {
            var request = [kSecClass: kSecClassGenericPassword, kSecAttrAccount: key] as [CFString: Any]

            switch operation {
            case .delete:
                request[kSecReturnData] = false

            case .read:
                request[kSecReturnData] = true

            case .write(let data):
                request[kSecValueData] = data
            }

            return request as CFDictionary
        }
    }
}

// MARK: - KeychainQueryOperation
fileprivate enum KeychainQueryOperation {
    case delete
    case read
    case write(data: Data)
}

// MARK: - KeychainQuery
fileprivate protocol KeychainQuery {
    func query(for operation: KeychainQueryOperation) -> CFDictionary
}

fileprivate extension KeychainQuery {
    func deleteItem() {
        SecItemDelete(query(for: .delete))
    }

    func saveData(data: Data) {
        SecItemAdd(query(for: .write(data: data)), nil)
    }

    func loadData() -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching(query(for: .read), &result)

        guard status == noErr, let data = result as? Data else {
            return nil
        }

        return data
    }
}
