//
//  ChannelsRow.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 21/5/24.
//

import SwiftUI

struct ChannelsRow: View {
    private let channel: Channel
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ChannelAvatar(url: channel.imageUrl)
                .frame(width: 60.0, height: 60.0)
                .clipShape(Circle())
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(channel.title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(Color.Text.main)
                
                Text(channel.subtitle)
                    .font(.system(size: 18))
                    .lineLimit(2)
                    .foregroundStyle(Color.Text.main)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(channel.lastUpdateTime.timeAgo())
                    .font(.system(size: 12))
                    .foregroundStyle(Color.Text.main)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Spacer()
                
                if channel.missedUpdatesNumber > 0 {
                    ZStack {
                        Circle()
                            .fill(channel.userSettings.isMuted
                                  ? Color.Extra.silver
                                  : Color.Text.attention)
                           
                        let text = channel.missedUpdatesNumber > 99 ? "99+" : String(channel.missedUpdatesNumber)
                        let size = channel.missedUpdatesNumber > 99 ? 11 : 13
                        Text(text)
                            .font(.system(size: CGFloat(size)))
                            .foregroundStyle(Color.Extra.taupe)
                    }
                    .frame(width: 26, height: 26)
                }
            }
        }
    }
}

fileprivate extension Date {
    func timeAgo() -> String {
        let daysAgo = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        let dateFormatter = DateFormatter()
        
        switch daysAgo {
        case 0:
            dateFormatter.dateFormat = "HH:mm"
        case 1...7:
            dateFormatter.dateFormat = "E"
        default:
            dateFormatter.dateFormat = "MM/dd/yy"
        }
        
        return dateFormatter.string(from: self)
    }
}
