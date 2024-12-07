//
//  ChatTableViewCell.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import UIKit

import SnapKit
import Then

final class ChatTableViewCell: BaseTableViewCell {
    private let profileImageView = RoundedImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let senderNameLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .regular13
    }
    
    private let contentStackView = UIStackView().then {
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private let chatContentView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brandInactive.cgColor
    }
    
    private let chatLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.font = .regular13
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .textSecondary
        $0.font = .regular11
    }
    
    private let imageStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    private let firstImageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    private let secondImageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    
    private lazy var firstImageView = UIImageView()
    private lazy var secondImageView = UIImageView()
    private lazy var thirdImageView = UIImageView()
    private lazy var forthImageView = UIImageView()
    private lazy var fifthImageView = UIImageView()
    
    private lazy var imageViewList: [UIImageView] = {
        let list = [firstImageView, secondImageView, thirdImageView, forthImageView, fifthImageView]
        
        return list.map {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
            return $0
        }
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        firstImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        secondImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        imageViewList.forEach {
            $0.snp.removeConstraints()
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .clear
    }

    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(senderNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(chatContentView)
        contentStackView.addArrangedSubview(imageStackView)
        imageStackView.addArrangedSubview(firstImageStackView)
        imageStackView.addArrangedSubview(secondImageStackView)
        
        chatContentView.addSubview(chatLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(34)
        }
        
        senderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(senderNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(senderNameLabel)
            make.width.lessThanOrEqualTo(250)
            make.bottom.lessThanOrEqualToSuperview().inset(6)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentStackView.snp.trailing).offset(8)
            make.bottom.equalTo(contentStackView)
        }
    }

    func configureCell(chat: ChatPresentationModel) {
        profileImageView.setImage(imageURL: chat.profileImage, placeHolder: .profilePlaceholder)
        senderNameLabel.text = chat.senderName
        
        chatContentView.isHidden = chat.content.isEmpty
        chatLabel.text = chat.content
        
        dateLabel.text = chat.sendDate
        
        configureChatImages(chat.images)
    }
    
    private func configureChatImages(_ imageURLs: [String]) {
        imageStackView.isHidden = imageURLs.isEmpty
        imageURLs.enumerated().forEach { (idx, imageURL) in
            imageViewList[idx].setImage(imageURL: imageURL)
        }
        
        switch imageURLs.count {
        case 1:
            firstImageStackView.addArrangedSubview(firstImageView)
        case 2:
            [firstImageView, secondImageView].forEach {
                firstImageStackView.addArrangedSubview($0)
            }
        case 3:
            [firstImageView, secondImageView, thirdImageView].forEach {
                firstImageStackView.addArrangedSubview($0)
            }
        case 4:
            [firstImageView, secondImageView].forEach {
                firstImageStackView.addArrangedSubview($0)
            }
            [thirdImageView, forthImageView].forEach {
                secondImageStackView.addArrangedSubview($0)
            }
        case 5:
            [firstImageView, secondImageView, thirdImageView].forEach {
                firstImageStackView.addArrangedSubview($0)
            }
            
            [forthImageView, fifthImageView].forEach {
                secondImageStackView.addArrangedSubview($0)
            }
        default:
            return
        }
        
        configureImageStackViewLayout(count: imageURLs.count)
    }
    
    private func configureImageStackViewLayout(count: Int) {
        if count > 1 {
            firstImageStackView.subviews.forEach {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(80).priority(.high)
                }
            }
            
            secondImageStackView.subviews.forEach {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(80).priority(.high)
                }
            }
        } else {
            firstImageView.snp.makeConstraints { make in
                make.height.equalTo(162).priority(.high)
            }
        }
    }
    
}
