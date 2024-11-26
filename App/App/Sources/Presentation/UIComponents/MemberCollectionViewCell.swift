//
//  MemberCollectionViewCell.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import UIKit

import SnapKit
import Then

final class MemberCollectionViewCell: BaseCollectionViewCell {
    
    private var profileImageView = RoundedImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private var nameLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .regular15
        $0.textAlignment = .center
    }
    
    override func configureView() {
        contentView.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
            make.size.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureCell(_ imageURL: String?, _ name: String) {
        profileImageView.setImage(imageURL: imageURL, placeHolder: .profilePlaceholder)
        nameLabel.text = name
    }
}
