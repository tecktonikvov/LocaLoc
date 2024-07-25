//
//  ShareItem.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 25/7/24.
//

import SwiftUI

struct ShareItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }

    let image: Image
    let title: String
    let link: URL
    
    lazy var sharePreview = SharePreview(title, image: image)
}
