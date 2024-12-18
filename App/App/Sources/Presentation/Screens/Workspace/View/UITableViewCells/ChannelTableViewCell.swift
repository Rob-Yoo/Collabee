//
//  ChannelTableViewCell.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import UIKit

import SnapKit
import Then

final class ChannelTableViewCell: BaseTableViewCell {
    
    private let channelIcon = UIImageView().then {
        let conf = UIImage.SymbolConfiguration(font: .regular15)
        
        $0.image = .channelIcon?.withConfiguration(conf)
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .textSecondary
    }
    
    private let channelNameLabel = UILabel().then {
        $0.textColor = .textSecondary
        $0.font = .regular15
    }
    
    private let unreadCountTagView = UnreadCountTagView()
    
    override func configureHierarchy() {
        contentView.addSubview(channelIcon)
        contentView.addSubview(channelNameLabel)
        contentView.addSubview(unreadCountTagView)
    }
    
    override func configureLayout() {
        channelIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.size.equalTo(15)
        }
        
        channelNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(channelIcon.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        
        unreadCountTagView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.height + 1)
            make.width.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.width + 2)
        }
    }
    
    func configureCell(_ name: String) {
        let unreads = Int.random(in: 0..<15)
        
        self.channelNameLabel.text = name
        
        if unreads < 7 {
            unreadCountTagView.isHidden = true
            channelNameLabel.textColor = .textSecondary
            channelNameLabel.font = .regular15
        } else {
            unreadCountTagView.isHidden = false
            unreadCountTagView.countLabel.text = unreads.formatted()
            channelNameLabel.font = .bold15
            channelNameLabel.textColor = .textPrimary
            
            unreadCountTagView.snp.updateConstraints { make in
                make.height.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.height + 4)
                make.width.equalTo(unreadCountTagView.countLabel.intrinsicContentSize.width + 10)
            }
        }
    }
}
