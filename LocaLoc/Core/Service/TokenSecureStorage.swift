//
//  TokenSecureStorage.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import Foundation

protocol TokenSecureStorage {
    func saveToken(_ token: String)
    func clearToken()
    func token() -> String?
}
