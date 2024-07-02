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
    
    // MARK: - Private
//    private func checkIsMainThread(line: Int = #line) {
//        if !Thread.current.isMainThread {
//            fatalError("SwiftData transactions should be performed on main thread, line: \(line)")
//        }
//    }
}

// MARK: - AppLocalStorage
extension AppLocalStorage: LocalStorage {
    public func fetchModelsWith<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws -> [T] where T: PersistentModel {
       // checkIsMainThread()
        let descriptor = descriptor ?? FetchDescriptor<T>()
                
        let fetchResult = try modelContext.fetch(descriptor)
        return fetchResult
    }
    
    public func addModel(model: any PersistentModel) {
        //checkIsMainThread()
        modelContext.insert(model)
    }
    
    public func delete(model: any PersistentModel) {
       // checkIsMainThread()
        modelContext.delete(model)
    }
}
