//
//  ShareSheetPresenter.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 3/8/24.
//

import UIKit

final class ShareSheetPresenter {
    // MARK: - Init
    private init() {}
    
    // MARK: - Public
    static func show(withType type: ShareableItemType,
                     title: String,
                     subtitle: String? = nil,
                     previewImage: UIImage? = nil,
                     animated: Bool = true,
                     completion: (() -> Void)? = nil) {
        let item = ShareableItem(
            type: type,
            title: title,
            subtitle: subtitle,
            previewImage: previewImage
        )
        
        let activityVC = UIActivityViewController(
            activityItems: [item],
            applicationActivities: nil
        )
        
        UIApplication
            .shared
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: animated, completion: completion)
    }
}
