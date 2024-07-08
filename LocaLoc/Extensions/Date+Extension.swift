//
//  Date+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 8/7/24.
//

import Foundation

extension Date {
    static var timeZoneIndependentCurrentDate: Date {
        let timezone = TimeZone(abbreviation: "GMT")
        let seconds = TimeInterval(timezone?.secondsFromGMT(for: Date()) ?? 0)
        return Date(timeInterval: seconds, since: Date())
    }
}
