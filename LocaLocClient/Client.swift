//
//  Client.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import K_Logger
import FirebaseCore
import FirebaseFirestore

enum ClientError: Error {
    case dataIsMissed
}

public class Client {
    private let database: Firestore
        
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
    func setData(documentId: String, collectionName: String, data: Encodable) async throws {
        let data = try JSONEncoder().encode(data)
        let dictionary = try data.asDictionary()
        
        try await database
            .collection(collectionName)
            .document(documentId)
            .setData(dictionary)
        log(message: "Data saved to collection: \"\(collectionName)\"", dictionary: dictionary)
    }
    
    func data<T: Decodable>(documentId: String, collectionName: String, type: T.Type) async throws -> T? {
        let docRef = database.collection(collectionName).document(documentId)
        let document = try await docRef.getDocument()
        
        if document.exists {
            guard let dictionary = document.data() else { 
                log(message: "Requested data does not exist, documentId: \"\(documentId)\", collectionName: \"\(collectionName)\"", dictionary: [:])
                throw ClientError.dataIsMissed
            }
            
            log(message: "Data fetched from collection: \"\(collectionName)\"", dictionary: dictionary)

            let json = try JSONSerialization.data(withJSONObject: dictionary)
            let object = try JSONDecoder().decode(type.self, from: json)
            
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
