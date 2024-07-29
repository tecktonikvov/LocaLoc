//
//  NavigationPath+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 29/7/24.
//

import SwiftUI

extension NavigationPath {
    mutating func popToRoot() {
        self = NavigationPath()
    }
}
