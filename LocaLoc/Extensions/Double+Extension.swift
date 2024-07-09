//
//  Double+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 9/7/24.
//

import Foundation

extension Double {
    var nanoseconds: UInt64  {
        UInt64(self * 1_000_000_000)
    }
}
