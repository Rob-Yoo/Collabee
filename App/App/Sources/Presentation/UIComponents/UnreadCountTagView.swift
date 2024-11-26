//
//  UnreadCountTagView.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import UIKit

import SnapKit
import Then

final class UnreadCountTagView: BaseView {
    let countLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .white
    }
    
    override func configureView() {
        self.backgroundColor = .brandMainTheme
        self.layer.cornerRadius = 8
    }
    
    override func configureHierarchy() {
        self.addSubview(countLabel)
    }
    
    override func configureLayout() {
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
