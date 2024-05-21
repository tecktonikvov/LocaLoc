//
//  Color.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 20/5/24.
//

import SwiftUI

extension Color {
    struct ContentPrimary {
        private init() {}
        
        static let border = Color("text_main")
        static let background = Extra.taupe
        static let separator = Color("separator_color")
      
        struct Text {
            private init() {}
            
            static let main = Color("text_main")
            static let subtitle = Color("text_main")
            static let attention = Color("attention")
        }
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
