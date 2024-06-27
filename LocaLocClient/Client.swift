//
//  Client.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import K_Logger
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

enum ClientError: Error {
    case dataIsMissed
}

public final class Client {
    private let database: Firestore
    private let storage: Storage
        
    // MARK: - Init
    public init() {
        database = Firestore.firestore()
        storage = Storage.storage()
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
    
    private func log(message: String, arrayOfDictionaries: Array<[String: Any]>) {
        Task {
            let jsonData = (try? JSONSerialization.data(withJSONObject: arrayOfDictionaries, options: .prettyPrinted)) ?? Data()
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
    
    func updateData(in collectionName: String, for documentId: String, data: [String: Any]) async throws {
        try await database
            .collection(collectionName)
            .document(documentId)
            .updateData(data)
        log(message: "Field(s) updated in collection: \"\(collectionName)\"", dictionary: data)
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
    
    func filteredData(filter: Filter, collectionName: String) async throws -> [[String: Any]] {
        let querySnapshot = try await database
            .collection(collectionName)
            .whereFilter(filter)
            .getDocuments()
        
        let documents = querySnapshot.documents
        let dictionaries = documents.map { $0.data() }
        
        log(message: "Data fetched from collection: \"\(collectionName)\"", arrayOfDictionaries: dictionaries)
        
        return dictionaries
    }
    
    func uploadData(_ data: Data, folderName: String, fileName: String) async throws -> URL {
        let filePath = folderName + "/" + fileName
        let reference = storage.reference(withPath: filePath)
        
        //let token = try await Auth.auth().currentUser?.getIDToken() ?? ""
        
        //try await Auth.auth().signIn(
                
        _ = try await reference.putDataAsync(data)
        
        let url = try await reference.downloadURL()

        return url
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
