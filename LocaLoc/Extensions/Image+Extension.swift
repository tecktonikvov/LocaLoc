//
//  Image+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import SwiftUI

extension Image {
    func navBarStyled() -> some View {
        self
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.Text.main)
            .shadow(color: .black, radius: 10, y: 4)
    }
}
