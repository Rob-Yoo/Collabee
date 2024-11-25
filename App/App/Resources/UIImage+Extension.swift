//
//  UIImage+Extension.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit
import ImageIO

extension UIImage {
    
    func resizeImage(_ size: CGSize) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        guard let data = self.pngData(),
              let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else { return nil }
        
        let resizedImage = UIImage(cgImage: cgImage)
        return resizedImage
    }
    
    static var xIcon = UIImage(systemName: "xmark")
    static var channelIcon = UIImage(systemName: "number")
    static var plusIcon = UIImage(systemName: "plus")
    static var leftArrowIcon = UIImage(systemName: "chevron.left")
    static var rightArrowIcon = UIImage(systemName: "chevron.right")
    static var downArrowIcon = UIImage(systemName: "chevron.down")
    static var threeDotsIcon = UIImage(systemName: "ellipsis")
    static var bulletListIcon = UIImage(systemName: "list.bullet")
    static var inviteIcon = UIImage(systemName: "person.fill.badge.plus")
}
