//
//  TextEditorWithPlaceholder.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 28/7/24.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: LocalizedStringKey
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeholder)
                        .padding(.top, 10)
                        .opacity(0.6)
                    Spacer()
                }
                .padding(.leading, 4)
            }
            
            TextEditor(text: $text)
        }
    }
}

