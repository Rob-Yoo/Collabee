//
//  RoundedTextButton.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit

final class RoundedTextButton: BaseButton {
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
    }
    
    override func configureButton() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .bold14
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

}
