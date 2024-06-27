//
//  CachedCenteredImage.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 27/6/24.
//

import SwiftUI

@MainActor
fileprivate struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    // Input dependencies
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    // Downloaded image
    @State var image: UIImage? = nil
    
    init(url: URL?,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadPhoto()
                        }
                    }
            }
        }
    }
    
    // Downloads if the image is not cached already
    // Otherwise returns from the cache
    private func downloadPhoto() async -> UIImage? {
        do {
            guard let url else { return nil }
            
            // Check if the image is cached already
            if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
                return UIImage(data: cachedResponse.data)
            } else {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                // Save returned image data into the cache
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
                
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                return image
            }
        } catch {
            print("Error downloading: \(error)")
            return nil
        }
    }
}

struct CachedCenteredImage: View {
    private let url: URL?
    private let placeholderImageName: String
    
    private let uiImage: UIImage?

    init(url: URL?, placeholderImageName: String) {
        self.url = url
        self.placeholderImageName = placeholderImageName
        self.uiImage = nil
    }
    
    init(uiImage: UIImage) {
        self.url = nil
        self.placeholderImageName = "photo"
        self.uiImage = uiImage
    }
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { containerGR in
                if let uiImage {
                    Image(uiImage: uiImage)
                        .imageModifier(geometry: containerGR)
                } else if let url {
                    AsyncCachedImage(url: url) { image in
                        image
                            .imageModifier(geometry: containerGR)
                    } placeholder: {
                       Rectangle()
                    }
                } else {
                    Image(systemName: placeholderImageName)
                        .resizable()
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
