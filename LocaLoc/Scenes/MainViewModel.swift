//
//  HomeModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Combine
import SwiftUI

struct HomeModel {
    let tabScenes: [TabScene<AnyView>]
}

class HomeViewModel: ObservableObject {
    @Published private(set) var error: Error? = nil

    let model: HomeModel
    let didNavigateBack = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(model: HomeModel) {
        self.model = model
    }

    func backAction() {
        didNavigateBack.send(())
    }
}
