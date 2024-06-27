//
//  UsernameAvailabilityChecker.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 9/6/24.
//

import Foundation

protocol UsernameManager {
    func setUserName(_ username: String) async throws
    func isUsernameFree(_ username: String) async throws -> Bool
}
