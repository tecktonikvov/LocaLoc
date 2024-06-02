//
//  LocalStorage.swift
//  LocaLocLocalStore
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import SwiftData
import SwiftUI

public class LocalStorage {
    private let modelContext: ModelContext
    
    // MARK: - Init
    public init(with types: any PersistentModel.Type...) throws {
        let config = ModelConfiguration()
        let modelContainer = try ModelContainer(for: Schema(types), configurations: config)
        let modelContext = ModelContext(modelContainer)
        
        self.modelContext = modelContext
    }
    
    // MARK: - Public
    public func fetchModelsWith<T>(model: T.Type) throws -> [T] where T: PersistentModel {
        let descriptor = FetchDescriptor<T>()
                
        let fetchResult = try modelContext.fetch(descriptor)
        return fetchResult
    }
    
    public func addModel(model: any PersistentModel) {
        modelContext.insert(model)
    }
    
    public func delete(model: any PersistentModel) {
        modelContext.delete(model)
    }
    
    public func save() throws {
        try modelContext.save()
    }
}
