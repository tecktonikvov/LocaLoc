//
//  Color.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 20/5/24.
//

import SwiftUI

extension Color {
    static let border = Color("text_main")
    static let background = Color("background")
    static let separator = Color("separator")
    
    
    static let backgroundGradientTop = Color("background_gradient_top")
    static let backgroundGradientBottom = Color("background_gradient_bottom")

    struct Text {
        private init() {}
        
        static let main = Color("text_main")
        static let subtitle = Color("text_main")
        static let attention = Color("attention")
    }
    
    struct Extra {
        private init() {}
        
        static let battleshipGray = Color("battleship_gray")
        static let isabelline = Color("isabelline")
        static let melon = Color("melon")
        static let silver = Color("silver")
        static let taupe = Color("taupe")
    }
}
