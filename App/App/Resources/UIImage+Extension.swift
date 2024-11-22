//
//  UIImage+Extension.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit

extension UIImage {
    
    func resizeImage(_ size: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: size)
        let resizedImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
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
}
