//
//  ChatInputView.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import UIKit

import SnapKit
import Then

final class ChatInputView: BaseView {
    
    let chatInputTextView = UITextView().then {
        $0.font = .regular13
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
    }
    
    let addFileButton = UIButton().then {
        $0.setImage(.plusIcon, for: .normal)
        $0.tintColor = .textSecondary
    }
    
    let sendButton = UIButton().then {
        $0.setImage(.disabledSendIcon, for: .normal)
        $0.tintColor = .brandInactive
        $0.isEnabled = false
    }
    
    let placeholderLabel = UILabel().then {
        $0.text = "메세지를 입력하세요"
        $0.textAlignment = .left
        $0.font = .regular13
        $0.textColor = .textSecondary
    }
    
    override func configureView() {
        backgroundColor = .brandGray
        layer.cornerRadius = 8
    }
    
    override func configureHierarchy() {
        addSubview(chatInputTextView)
        addSubview(addFileButton)
        addSubview(sendButton)
        addSubview(placeholderLabel)
    }
    
    override func configureLayout() {
        addFileButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.greaterThanOrEqualToSuperview().inset(10)
            make.leading.bottom.equalToSuperview().inset(10)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.greaterThanOrEqualToSuperview().inset(10)
            make.trailing.bottom.equalToSuperview().inset(10)
        }
        
        chatInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            make.height.equalTo(1) // updateTextViewHeight 메서드에서 높이 조정 다시함
            make.bottom.equalToSuperview().inset(5)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(chatInputTextView).inset(7)
            make.verticalEdges.equalTo(chatInputTextView)
        }
        
        updateTextViewHeight()
    }
    
    func updateTextViewHeight() {
        let lineHeight = UIFont.regular13.lineHeight
        let size = CGSize(width: chatInputTextView.frame.width, height: .infinity)
        let estimatedSize = chatInputTextView.sizeThatFits(size)
        let maxHeight = lineHeight * 4
        let newHeight = min(estimatedSize.height, maxHeight)
        
        chatInputTextView.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
        
        chatInputTextView.isScrollEnabled = estimatedSize.height > maxHeight
        layoutIfNeeded()
    }
}
