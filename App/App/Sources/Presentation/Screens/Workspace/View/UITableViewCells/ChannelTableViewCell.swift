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
    
    override func configureHierarchy() {
        contentView.addSubview(channelIcon)
        contentView.addSubview(channelNameLabel)
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
    }
    
    func configureCell(_ name: String) {
        self.channelNameLabel.text = name
    }
}
