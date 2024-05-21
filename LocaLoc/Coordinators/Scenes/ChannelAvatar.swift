//
//  ChannelAvatar.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI
import CachedAsyncImage

struct ChannelAvatar: View {
    private let url: URL?
  
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        if let url {
            CachedAsyncImage(url: url)
        } else {
            Image(systemName: "location.circle.fill")
                .resizable()
                .foregroundStyle(Color.Extra.battleshipGray)
        }
    }
}
