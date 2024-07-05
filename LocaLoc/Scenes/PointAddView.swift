//
//  PointAddView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import SwiftUI
import Factory

struct PointAddView: View {
    @Injected(\.addressProvider) private var addressProvider
    
    @State var address = ""
    @State var isLoading = true
    
    private let coordinates: Coordinates
    
    // MARK: - Output
    var onCreateApproved: () -> Void
    var onClose: () -> Void

    // MARK: - Init
    init(coordinates: Coordinates, onCreateApproved: @escaping () -> Void, onClose: @escaping () -> Void) {
        self.coordinates = coordinates
        self.onClose = onClose
        self.onCreateApproved = onCreateApproved
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Create new point")
                    .font(.title)
                Spacer()
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.Text.main)
                }
                .padding(.trailing, 4)
            }
            
            Text(address)
            
            if isLoading {
                VStack(alignment: .center) {
                    PointAnimationView()
                        .frame(width: 32, height: 32)
                        .padding(.bottom)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 90)
            } else {
                Button {
                    onCreateApproved()
                } label: {
                    Spacer()
                    Text("Create")
                        .foregroundColor(Color.Extra.taupe)
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.brand)
                )
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.background)
        )
        .task {
            do {
                let address = try await addressProvider.address(by: coordinates)
                self.address = address.line
            } catch {
                print(error)
            }
            
            isLoading = false
        }
    }
}
