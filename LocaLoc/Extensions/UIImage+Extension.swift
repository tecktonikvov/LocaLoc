//
//  UIImage+Extension.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import UIKit

extension UIImage {
    @MainActor
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(
            frame: CGRect(origin: .zero,
                          size: CGSize(width: width,
                                       height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

