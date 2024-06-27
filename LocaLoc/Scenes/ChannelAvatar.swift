//
//  ChannelAvatar.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI

struct ChannelAvatar: View {
    private let url: URL?
  
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        CachedCenteredImage(
            url: url,
            placeholderImageName: "location.circle.fill")
            .frame(width: 80, height: 80)
            .clipShape(Circle())
    }
}
