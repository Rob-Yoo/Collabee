//
//  RoundedImageView.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit

final class RoundedImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
