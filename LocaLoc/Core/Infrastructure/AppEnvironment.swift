//
//  Environment.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 2/8/24.
//

import Foundation

enum AppEnvironment: String {
    case development
    case testFlight
    case appStore
    
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var currentEnvironment: AppEnvironment {
        if isDebug {
            return .development
        } else if isTestFlight {
            return .testFlight
        } else {
            return .appStore
        }
    }
    
    static func saveCurrentAppEnvironment() {
        UserDefaults.standard.setValue(currentEnvironment.rawValue, forKey: "last_app_environment")
    }
    
    static var isAppEnvironmentWasChanged: Bool? {
        guard let lastAppEnvironmentString = UserDefaults.standard.string(forKey: "last_app_environment"),
              let appEnvironment = AppEnvironment(rawValue: lastAppEnvironmentString) else {
            return nil
        }
        
        return appEnvironment != AppEnvironment.currentEnvironment
    }
}
