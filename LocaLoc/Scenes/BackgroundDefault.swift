//
//  BackgroundDefault.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 2/6/24.
//

import SwiftUI

struct BackgroundDefault: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                LinearGradient(gradient: Gradient(
                    colors: [.backgroundGradientTop,   .backgroundGradientBottom]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            }
    }
}

extension View {
    func backgroundDefault() -> some View {
        modifier(BackgroundDefault())
    }
}
