//
//  Client.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import FirebaseCore
import FirebaseFirestore

fileprivate extension String {
    static let usersCollection = "users"
}

public final class Client {
    private let database: Firestore
    
    // MARK: - Init
    public init() {
        FirebaseApp.configure()
        database = Firestore.firestore()
    }
    
    // MARK: - Private
    public func setUserData(userId: String, data: Encodable) {
        Task {
            do {
                let data = try data.asDictionary()
                
                try await database
                    .collection(.usersCollection)
                    .document(userId)
                    .setData(data)
                print("Document added with ID: \(data)")
            } catch {
                print("Error adding document: \(error)")
            }
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let serialized = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let dictionary = serialized as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
