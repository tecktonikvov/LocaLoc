//
//  LimitedTextField.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 28/6/24.
//

import SwiftUI

struct LimitedTextField: View {
    @State private var errorText = ""
    @State private var showTips = false

    private let max: Int
    private let min: Int
    private let title: String
    
    @Binding private var output: String

    // MARK: - Init
    init(max: Int, min: Int, title: String, output: Binding<String>) {
        self.max = max
        self.min = min
        self.title = title
        self._output = output
    }
    
    var body: some View {
        VStack {
            TextField(title, text: $output.max(max)) { isEditing in
                showTips = isEditing
            }
            
            HStack {
                if showTips {
                    if !errorText.isEmpty {
                        Text(errorText)
                            .foregroundColor(Color.Text.attention)
                    } else {
                        let amount = symbolsLeft()
                        Text("\(amount) symbols left")
                            .foregroundColor(amount <= 0 ? Color.Text.attention : Color.Text.main)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.footnote)
        }
        .onChange(of: output) { _, _ in
            if output.count < min {
                errorText = "At least \(min) characters"
            } else {
                errorText = ""
            }
        }
    }
    
    // MARK: - Private
    private func symbolsLeft() -> Int {
        let amount = max - output.count
        return Swift.max(0, amount)
    }
}
