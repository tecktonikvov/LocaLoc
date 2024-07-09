//
//  Collection+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 9/7/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
