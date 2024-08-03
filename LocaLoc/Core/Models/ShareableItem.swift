//
//  ShareableItem.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 3/8/24.
//

import LinkPresentation

enum ShareableItemType {
    case url(URL)
    case text(String)
    case image(UIImage)
}

final class ShareableItem: NSObject {
    private let type: ShareableItemType
    private let title: String
    private let subtitle: String?
    private let previewImage: UIImage?
    
    // MARK: - Init
    init(type: ShareableItemType, title: String, subtitle: String? = nil, previewImage: UIImage? = nil) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.previewImage = previewImage

        super.init()
    }
}

extension ShareableItem: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return title
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        switch type {
        case .image(let image):
            return image
        case .url(let url):
            return url
        case .text(let text):
            return text
        }
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.title = title

        if let previewImage {
            metadata.iconProvider = NSItemProvider(object: previewImage)
        }
        
        if let subtitle {
            metadata.originalURL = URL(fileURLWithPath: subtitle)
        }
        
        switch type {
        case .url(let url):
            metadata.url = url
        default:
            break
        }
        
        return metadata
    }
}
