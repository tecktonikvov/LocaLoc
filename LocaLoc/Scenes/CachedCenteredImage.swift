//
//  CachedCenteredImage.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 27/6/24.
//

import SwiftUI
import SDWebImageSwiftUI

enum CachedCenteredImageType {
    case url(URL, Image)
    case image(Image)
    case uIImage(UIImage)
}

struct CachedCenteredImage: View {
    private let type: CachedCenteredImageType
    
    // MARK: - Init
    init(type: CachedCenteredImageType) {
        self.type = type
    }
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { containerGR in
                switch type {
                case .image(let image):
                    image
                        .imageModifier(geometry: containerGR)
                case .uIImage(let uiImage):
                    Image(uiImage: uiImage)
                        .imageModifier(geometry: containerGR)
                case let .url(url, placeholder):
                    WebImage(url: url) { image in
                        image
                            .resizable()
                            .imageModifier(geometry: containerGR)
                    } placeholder: {
                        placeholder
                            .resizable()
                    }
                }
            }
        }
    }
}

fileprivate extension Image {
    func imageModifier(geometry: GeometryProxy) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
   }
}
