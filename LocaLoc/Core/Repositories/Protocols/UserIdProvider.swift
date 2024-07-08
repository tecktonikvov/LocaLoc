//
//  UserIdProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import Foundation

protocol UserIdProvider {
    func userId() throws -> String
}
