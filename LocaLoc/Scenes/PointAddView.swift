//
//  PointAddView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import SwiftUI
import Factory
import K_Logger

struct PointAddView: View {
    @Injected(\.addressProvider) private var addressProvider
    
    @State var addressString = ""
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
        VStack {
            Spacer()
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
                
                Text(addressString)
                
                if isLoading {
                    VStack(alignment: .center) {
                        PointAnimationView()
                            .frame(width: 32, height: 32)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding(.bottom)
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
                    isLoading = false

                    withAnimation {
                        self.addressString = address.line
                    }
                } catch {
                    Log.error("Address request error: \(error)", module: "PointAddView")
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }
}
