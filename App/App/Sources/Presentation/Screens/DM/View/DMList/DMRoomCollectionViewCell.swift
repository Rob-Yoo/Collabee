//
//  DMRoomCollectionViewCell.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import UIKit

import SnapKit
import Then

final class DMRoomCollectionViewCell: BaseCollectionViewCell {
    
    private let profileImageView = RoundedImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .regular15
    }
    
    private let lastMessageLabel = UILabel().then {
        $0.textColor = .textSecondary
        $0.font = .regular13
    }
    
    private let lastDateLabel = UILabel().then {
        $0.textColor = .textSecondary
        $0.font = .regular13
        $0.textAlignment = .right
    }
    
    private let unreadCountTagView = UnreadCountTagView()
    
    override func configureView() {
        contentView.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(lastDateLabel)
        contentView.addSubview(unreadCountTagView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(profileImageView.snp.height)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        lastMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        lastDateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.trailing.equalToSuperview()
        }
        
        unreadCountTagView.snp.makeConstraints { make in
            make.top.equalTo(lastDateLabel.snp.bottom).offset(3)
            make.trailing.equalToSuperview()
            make.height.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.height + 1)
            make.width.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.width + 2)
        }
    }
    
    func configureCell(_ model: DMRoomPresentationModel) {
        profileImageView.setImage(imageURL: model.profileImageURL, placeHolder: .profilePlaceholder)
        nameLabel.text = model.name
        lastMessageLabel.text = model.lastMessage
        lastDateLabel.text = model.lastDate
        
        if model.numberOfUnreadMessage == 0 {
            unreadCountTagView.isHidden = true
        } else {
            unreadCountTagView.isHidden = false
            unreadCountTagView.countLabel.text = model.numberOfUnreadMessage.formatted()
            
            unreadCountTagView.snp.updateConstraints { make in
                make.height.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.height + 4)
                make.width.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.width + 10)
            }
        }
    }
}
