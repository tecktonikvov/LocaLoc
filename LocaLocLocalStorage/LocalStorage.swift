//
//  LocalStorage.swift
//  LocaLocLocalStore
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import SwiftData
import Foundation

public protocol LocalStorage {
    func fetchModelsWith<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws -> [T] where T: PersistentModel
    func addModel(model: any PersistentModel)
    func delete(model: any PersistentModel)
    func deleteAllModels(withTypes types: any PersistentModel.Type...) throws
    func deleteAll<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws
}

public class AppLocalStorage {
    private let modelContext: ModelContext
    
    // MARK: - Init
    public init(with types: any PersistentModel.Type...) throws {
        let config = ModelConfiguration()
        let modelContainer = try ModelContainer(for: Schema(types), configurations: config)
        let modelContext = ModelContext(modelContainer)
        
        self.modelContext = modelContext
    }
}

// MARK: - AppLocalStorage
extension AppLocalStorage: LocalStorage {
    public func fetchModelsWith<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws -> [T] where T: PersistentModel {
        let descriptor = descriptor ?? FetchDescriptor<T>()
                
        let fetchResult = try modelContext.fetch(descriptor)
        return fetchResult
    }
    
    public func addModel(model: any PersistentModel) {
        modelContext.insert(model)
    }
    
    public func delete(model: any PersistentModel) {
        modelContext.delete(model)
    }
    
    public func deleteAllModels(withTypes types: any PersistentModel.Type...) throws {
        for type in types {
            try modelContext.delete(model: type)
        }
    }
    
    public func deleteAll<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws {
        let descriptor = descriptor ?? FetchDescriptor<T>()
        let fetchResult = try modelContext.fetch(descriptor)
        
        fetchResult.forEach {
            modelContext.delete($0)
        }
    }
}
