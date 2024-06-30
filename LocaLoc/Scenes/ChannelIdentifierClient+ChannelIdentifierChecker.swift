//
//  ChannelIdentifierClient+ChannelIdentifierChecker.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import LocaLocClient

extension ChannelIdentifierClient: ChannelIdentifierChecker {
    func isIdentifierFree(_ identifier: String) async throws -> Bool {
        try await isIdentifierFree(identifier: identifier)
    }
}
