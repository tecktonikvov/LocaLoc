//
//  Client.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import FirebaseCore
import FirebaseFirestore
import K_Logger

public final class Client {
    private let database: Firestore
    
    private let usersCollection = CollectionsKeys.usersCollection
    
    // MARK: - Init
    public init() {
        FirebaseApp.configure()
        database = Firestore.firestore()
    }
    
    // MARK: - Private
    private func log(message: String, dictionary: [String: Any]) {
        Task {
            let jsonData = (try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)) ?? Data()
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let message = message + "\n" + jsonString
            Log.info(message, module: "Client")
        }
    }
    
    // MARK: - Private
    public func setUserData(userId: String, data: Encodable) throws {
        Task {
            let data = try JSONEncoder().encode(data)
            let dictionary = try data.asDictionary()
            
            try await database
                .collection(usersCollection)
                .document(userId)
                .setData(dictionary)
            log(message: "User data has set to client", dictionary: dictionary)
//            let dicc = String(data: data, encoding: .utf8) ?? ""
//            print("Document added with ID: \(dicc)")
        }
    }
    
    public func userData<T: Decodable>(userId: String, type: T.Type) async throws -> T? {
        let docRef = database.collection(usersCollection).document(userId)
        let document = try await docRef.getDocument()
        
        if document.exists {
            guard let dictionary = document.data() else { 
                log(message: "Requested user data does not exist", dictionary: ["userId": userId])
                return nil
            }
            
            log(message: "Got user data", dictionary: dictionary)

            let json = try JSONSerialization.data(withJSONObject: dictionary)
            let object = try JSONDecoder().decode(type.self, from: json)

//            let dataDescription = dictionary.map(String.init(describing:))
//            print("Document data: \(dataDescription)")
            
            return object
        }
        
        return nil
    }
}

fileprivate extension Data {
    func asDictionary() throws -> [String: Any] {
        let serialized = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        
        guard let dictionary = serialized as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
