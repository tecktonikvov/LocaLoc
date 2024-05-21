//
//  TabScene.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 20/5/24.
//

import SwiftUI

struct TabScene<Content: View>: Identifiable {
    let id = UUID()
    let type: TabSceneType
    
    let content: Content
    
    init(type: TabSceneType, @ViewBuilder content: () -> Content) {
        self.type = type
        self.content = content()
    }
    
    var body: some View {
        self.content
    }
}
