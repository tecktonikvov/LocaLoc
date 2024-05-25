//
//  UserDefaults.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 23/5/24.
//

import SwiftUI

@propertyWrapper
struct StaticUserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    var wrappedValue: Value {
        get { getValue() }
        nonmutating set { setNewValue(newValue) }
    }
    
    var projectedValue: Binding<Value> {
        .init(get: getValue, set: { n in setNewValue(n)} )
    }
    
    private func getValue() -> Value {
        return container.object(forKey: key) as? Value ?? defaultValue
    }
    
    private func setNewValue(_ newValue: Value) {
        container.set(newValue, forKey: key)
        container.synchronize()
        print("update static defaults: \(newValue)")
    }
}


@propertyWrapper
struct UserDefaultDynamicBuilder<Value>: DynamicProperty {
    let inputProjectedValue: Binding<Value>
    @State var cachedValue: Value
    
    init(projectedValue: Binding<Value>) {
        self.inputProjectedValue = projectedValue
        self._cachedValue = State(initialValue: projectedValue.wrappedValue)
    }
    
    var wrappedValue: Value {
        get { cachedValue }
        nonmutating set { setNewValue(newValue) }
    }
    
    var projectedValue: Binding<Value> {
        .init(get: getValue, set: { n in setNewValue(n)} )
    }
    
    private func getValue() -> Value { cachedValue }
    
    private func setNewValue(_ newValue: Value) {
        inputProjectedValue.wrappedValue = newValue
        cachedValue = newValue
        print("update dynamaic builder: \(newValue)")
    }
}

struct UserSettings {
    /// static
    @StaticUserDefault(key: "number", defaultValue: 0)
    static var number
    
//    @StaticCustomUserDefault(key: "currentUser", defaultValue: UserModel(data: UserData(firstName: "", lastName: "", email: ""), authenticationStatus: .unauthorized))
//    static var user
}

struct SwiftUIView17: View {
//    @UserDefaultDynamicBuilder(projectedValue: UserSettings.$user)
//    var user
    
    @UserDefaultDynamicBuilder(projectedValue: UserSettings.$number)
    var number
    
    var body: some View {
//        Text("\(user.data.firstName)")
//        
//        Button("increase") {
//            user.data.firstName = "dsa +++"
//        }
        
        Text("\(number)")
        
        Button("increase") {
            number += 1
        }
    }
}

#Preview {
    SwiftUIView17()
}


@propertyWrapper
struct StaticCustomUserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard
    
    init(key: String, defaultValue: T, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    var wrappedValue: T {
        get { getValue() }
        nonmutating set { setNewValue(newValue) }
    }
    
    var projectedValue: Binding<T> {
        .init(get: getValue, set: { n in setNewValue(n)} )
    }
    
    private func getValue() -> T {
        let string = container.object(forKey: key) as? String ?? ""
        let decoded = decode(string: string)
        return decoded ?? defaultValue
    }
    
    private func decode(string: String) -> T?  {
        let data = Data(string.utf8)
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    private func setNewValue(_ newValue: T) {
        guard let string = encode(object: newValue) else {
            return
        }
        
        container.set(string, forKey: key)
        container.synchronize()
        print("update custom static defaults: \(newValue)")
    }
    
    private func encode(object: Codable) -> String? {
        if let data = try? JSONEncoder().encode(object) {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}
