//
//  DMTableViewCell.swift
//  App
//
//  Created by Jinyoung Yoo on 12/7/24.
//

import UIKit

import SnapKit
import Then

final class DMTableViewCell: BaseTableViewCell {
    
    private let profileImageView = RoundedImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .regular15
    }
    
    private let unreadCountTagView = UnreadCountTagView()
    
    override func configureView() {
        contentView.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(unreadCountTagView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.size.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        unreadCountTagView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.height + 1)
            make.width.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.width + 2)
        }
    }
    
    func configureCell(_ profileImageURL: String?, _ name: String) {
        let unreads = Int.random(in: 0..<5)
        
        profileImageView.setImage(imageURL: profileImageURL, placeHolder: .profilePlaceholder)
        nameLabel.text = name
        
        if unreads < 2 {
            unreadCountTagView.isHidden = true
            nameLabel.textColor = .textSecondary
            nameLabel.font = .regular15
        } else {
            unreadCountTagView.isHidden = false
            unreadCountTagView.countLabel.text = unreads.formatted()
            nameLabel.font = .bold15
            nameLabel.textColor = .textPrimary
            
            unreadCountTagView.snp.updateConstraints { make in
                make.height.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.height + 4)
                make.width.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.width + 10)
            }
        }
    }
}
