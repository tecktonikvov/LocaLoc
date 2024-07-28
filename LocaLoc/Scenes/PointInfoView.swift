//
//  PointInfoView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 11/7/24.
//

import SwiftUI

struct PointInfoView: View {
    private let address: String
    private let description: String
    private let updatedAt: Date
    private let isEditingAllowed: Bool
    
    private let onEditButtonTapped: (() -> Void)?

    @Binding private var showContent: Bool
    
    init(address: String, description: String, updatedAt: Date, isEditingAllowed: Bool, showContent: Binding<Bool>, onEditButtonTapped: (() -> Void)?) {
        self.address = address
        self.description = description
        self.updatedAt = updatedAt
        self.isEditingAllowed = isEditingAllowed
        self.onEditButtonTapped = onEditButtonTapped
        self._showContent = showContent
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(updatedAt.timeAgo())
            
            if !address.isEmpty {
                Text(address)
            }
            
            if !description.isEmpty {
                Text(description)
            }
            
            if isEditingAllowed {
                HStack {
                    Spacer()
                    Button {
                        onEditButtonTapped?()
                    } label: {
                        Text("Edit")
                            .underline()
                            .foregroundStyle(Color.Text.main)
                    }
                }
            }
        }
        .padding(8)
        .opacity(showContent ? 1 : 0)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(.gray.opacity(0.3), lineWidth: 1)
            .background(Color.Extra.taupe))
        .foregroundStyle(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

fileprivate extension Date {
    func timeAgo() -> LocalizedStringKey {
        let daysAgo = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        let dateFormatter = DateFormatter()
        
        switch daysAgo {
        case 0:
            dateFormatter.dateFormat = "HH:mm"
            return "Updated at: \(dateFormatter.string(from: self))"
        case 1...6:
            dateFormatter.dateFormat = "EEEE"
            return "Updated on: \(dateFormatter.string(from: self))"
        default:
            dateFormatter.dateFormat = "MM/dd/yy"
            return "Updated: \(dateFormatter.string(from: self))"
            
        }
    }
}
