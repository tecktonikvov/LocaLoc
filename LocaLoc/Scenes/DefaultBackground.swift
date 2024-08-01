//
//  DefaultBackground.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import SwiftUI

struct DefaultBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(
            colors: [.backgroundGradientTop, .backgroundGradientBottom]),
                       startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}
