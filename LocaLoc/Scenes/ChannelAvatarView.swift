//
//  ChannelAvatarView.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI

struct ChannelAvatarView: View {
    private let url: URL?
  
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        CachedCenteredImage(
            url: url,
            placeholderImageName: "channel_placeholder")
            .clipShape(Circle())
    }
}
