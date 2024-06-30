//
//  Binding+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import SwiftUI

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}
