//
//  PointAnimationView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import SwiftUI

struct PointAnimationView: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Image("point")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.brand)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                    animationAmount += 360
                }
            }
    }
}
