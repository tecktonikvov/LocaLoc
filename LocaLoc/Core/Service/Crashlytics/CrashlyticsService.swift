//
//  CrashlyticsService.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import Foundation//FirebaseCrashlytics

final class CrashlyticsService {
    private init() {
        //Crashlytics.crashlytics().setUserID("Unauthorised")
    }
        
    static let shared = CrashlyticsService()
    
    func set(userId: String) {
        //Crashlytics.crashlytics().setUserID(userId)
    }
    
    func set(userEmail: String) {
       // Crashlytics.crashlytics().setCustomValue(userEmail, forKey: "Email")
    }
    
    func set(username: String) {
        //Crashlytics.crashlytics().setCustomValue(username, forKey: "Username")
    }
}
