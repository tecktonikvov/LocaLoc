//
//  ChannelIdentifierChecker.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import Foundation

protocol ChannelIdentifierChecker {
    func isIdentifierFree(_ identifier: String) async throws -> Bool
}
