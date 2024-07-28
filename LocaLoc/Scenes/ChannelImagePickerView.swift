//
//  ChannelImagePickerView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 28/7/24.
//

import SwiftUI

struct ChannelImagePickerView: View {
    @State private var showPicker = false
    @Binding private var selectedImage: UIImage?
        
    // MARK: - Init
    init(selectedImage: Binding<UIImage?>) {
        self._selectedImage = selectedImage
    }
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack {
                Spacer()
                if let selectedImage {
                    CachedCenteredImage(type: .uIImage(selectedImage))
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.Text.main, Color.Extra.silver)
                        .cornerRadius(50)
                        .padding(4)
                        .frame(width: 180, height: 180)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .sheet(isPresented: $showPicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectedImage)
            }
        }
    }
}
