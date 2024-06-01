//
//  DataRepository.swift
//  DataRepository
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData

open class DataRepository {
    let modelContext: ModelContext
    
    init() throws {
        let config = ModelConfiguration()
        let modelContainer = try ModelContainer(for: UserPersistencyModel.self, ProfilePersistencyModel.self, configurations: config)
        let modelContext = ModelContext(modelContainer)
        
        self.modelContext = modelContext
    }
}
