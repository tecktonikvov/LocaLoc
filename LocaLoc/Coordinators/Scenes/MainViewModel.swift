//
//  MainViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Combine
import SwiftUI

struct MainModel {
    let tabScenes: [TabScene<AnyView>]
}

class MainViewModel: ObservableObject {
    @Published private(set) var error: Error? = nil

    let model: MainModel
    let didNavigateBack = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(model: MainModel) {
        self.model = model
    }

    func backAction() {
        didNavigateBack.send(())
    }
}
