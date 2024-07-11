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
    enum Field: Hashable {
        case address
        case description
    }
    
    @Injected(\.addressProvider) private var addressProvider
    
    @State private var isLoading = true
    
    @Binding private var addressString: String
    @Binding private var description: String
    @Binding private var showPoint: Bool
    @Binding private var lifetime: Int?
    @Binding private var emojiCode: String?
    @Binding private var heading: Double?

    @Binding private var isApproveButtonLoading: Bool
    
    @FocusState private var focusedField: Field?

    private let coordinates: Coordinates
    
    // MARK: - Output
    var onCreateApproved: () -> Void
    var onClose: () -> Void

    // MARK: - Init
    init(
        coordinates: Coordinates,
        addressString: Binding<String>,
        description: Binding<String>,
        showPoint: Binding<Bool>,
        lifetime: Binding<Int?>,
        emojiCode: Binding<String?>,
        heading: Binding<Double?>,
        isApproveButtonLoading: Binding<Bool>,
        onCreateApproved: @escaping () -> Void,
        onClose: @escaping () -> Void
    ) {
        self.coordinates = coordinates
        self.onClose = onClose
        self.onCreateApproved = onCreateApproved
        self._isApproveButtonLoading = isApproveButtonLoading
        self._addressString = addressString
        self._description = description
        self._showPoint = showPoint
        self._lifetime = lifetime
        self._emojiCode = emojiCode
        self._heading = heading
    }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Create new point")
                        .font(.title)
                    Spacer()
                    Button {
                        focusedField = nil
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.Text.main)
                    }
                    .padding(.trailing, 4)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Address")
                            .font(.title3)
                        TextField("", text: $addressString.max(Constants.pointAdressMaxCharactersLimit), axis: .vertical)
                            .padding(8)
                            .background(Color.clear)
                            .focused($focusedField, equals: .address)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: addressString) { _, newValue in
                                if newValue.contains("\n") {
                                    addressString = newValue.replacingOccurrences(of: "\n", with: "")
                                    focusedField = .description
                                }
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.title3)
                        TextField("", text: $description.max(Constants.pointDescriptionMaxCharactersLimit), axis: .vertical)
                            .padding(8)
                            .background(Color.clear)
                            .focused($focusedField, equals: .description)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: description) { _, newValue in
                                if newValue.contains("\n") {
                                    description = newValue.replacingOccurrences(of: "\n", with: "")
                                    focusedField = nil
                                }
                            }
                    }
                    
                    Toggle("Show point to users", isOn: $showPoint)
                        .tint(Color.brand)
                }
       
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
                        focusedField = nil
                        onCreateApproved()
                    } label: {
                        Spacer()
                        if isApproveButtonLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        } else {
                            Text("Create")
                                .foregroundColor(Color.Extra.taupe)
                        }
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
        .disabled(isApproveButtonLoading)
    }
}
