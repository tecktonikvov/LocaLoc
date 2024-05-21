//
//  SettingsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Combine

struct SettingsModel {
    let text: String
}

class SettingsViewModel: ObservableObject {
    @Published private(set) var error: Error? = nil

    private let model: SettingsModel
    let didNavigateBack = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init() {
        self.model = SettingsModel(text: "Test")
    }

    func backAction() {
        didNavigateBack.send(())
    }
}
