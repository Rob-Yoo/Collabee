//
//  UIImageView+ImageCache.swift
//  App
//
//  Created by Jinyoung Yoo on 11/24/24.
//

import UIKit
import Combine

import DataSource

private var cancellableKey = 0

extension UIImageView {
    
    private var imageCancellable: AnyCancellable? {
        get {
            return objc_getAssociatedObject(self, &cancellableKey) as? AnyCancellable
        }
        set {
            objc_setAssociatedObject(self, &cancellableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(imageURL: String, placeHolder: UIImage? = nil, size: CGSize? = nil) {

        imageCancellable?.cancel()

        DispatchQueue.main.async {
            self.image = placeHolder
        }

        imageCancellable = ImageCacheManager.shared.getImageData(imageURL)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, data in
                if let data, let image = UIImage(data: data) {
                    if let size {
                        owner.image = image.resize(size)
                    } else {
                        owner.image = image
                    }
                }
            }
    }
}
