//
//  UIImage+Extension.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit
import ImageIO

extension UIImage {
    
    func resize(_ size: CGSize) -> UIImage {
        let originalSize = self.size
        let ratio = originalSize.width / originalSize.height
        let targetSize = originalSize.width > originalSize.height ?
            CGSize(width: size.width, height: size.width / ratio) :
            CGSize(width: size.width * ratio, height: size.width)
        let render = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        print(resizedImage.jpegData(compressionQuality: 1)!)
        return resizedImage
    }
    
    static func downsample(_ data: Data, _ size: CGSize) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else { return nil }
        
        let resizedImage = UIImage(cgImage: cgImage)
        print(data)
        print(resizedImage.jpegData(compressionQuality: 1)!)
        return resizedImage
    }
    
    
    static var xIcon = UIImage(systemName: "xmark")
    static var xCircleIcon = UIImage(named: "xmark.circle")
    static var disabledSendIcon = UIImage(systemName: "paperplane")
    static var enabledSendIcon = UIImage(systemName: "paperplane.fill")
    static var channelIcon = UIImage(systemName: "number")
    static var plusIcon = UIImage(systemName: "plus")
    static var leftArrowIcon = UIImage(systemName: "chevron.left")
    static var rightArrowIcon = UIImage(systemName: "chevron.right")
    static var downArrowIcon = UIImage(systemName: "chevron.down")
    static var threeDotsIcon = UIImage(systemName: "ellipsis")
    static var bulletListIcon = UIImage(systemName: "list.bullet")
    static var inviteIcon = UIImage(systemName: "person.fill.badge.plus")
    static var homeFillIcon = UIImage(systemName: "house.fill")
    static var homeIcon = UIImage(systemName: "house")
    static var dmFillIcon = UIImage(systemName: "message.fill")
    static var dmIcon = UIImage(systemName: "message")
    static var settingFillIcon = UIImage(systemName: "gearshape.fill")
    static var settingIcon = UIImage(systemName: "gearshape")
}
