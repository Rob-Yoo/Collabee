//
//  BaseButton.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit

class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureButton()
        self.configureHierarchy()
        self.configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {}
    func configureHierarchy() {}
    func configureLayout() {}
}
