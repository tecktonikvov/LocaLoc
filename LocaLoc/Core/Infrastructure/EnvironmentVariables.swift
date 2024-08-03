//
//  EnvironmentVariables.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 3/8/24.
//

import Foundation

struct EnvironmentVariables {
    enum Keys {
        static let gMapsApiKey = "GMAPS_API_KEY"
        static let hostUrl = "HOST_URL"
    }
        
    static let gMapsApiKey: String = {
        ejectValue(for: Keys.gMapsApiKey)
    }()
    
    static let hostUrl: String = {
       ejectValue(for: Keys.hostUrl)
    }()
    
    // MARK: - Private
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        
        return dict
    }()
    
    private static func ejectValue<T>(for key: String) -> T {
        guard let value = EnvironmentVariables.infoDictionary[key] as? T else {
            fatalError("Value for key: \(key), was not found in plist")
        }
        
        return value
    }
    
    // MARK: - Init
    private init() {}
}
