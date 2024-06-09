//
//  HomeViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import SwiftUI

struct HomeModel {
    let tabScenes: [TabScene<AnyView>]
}

@Observable class HomeViewModel {
    private(set) var error: Error? = nil

    let model: HomeModel
    
    // MARK: - Init
    init(model: HomeModel) {
        self.model = model
    }
}
