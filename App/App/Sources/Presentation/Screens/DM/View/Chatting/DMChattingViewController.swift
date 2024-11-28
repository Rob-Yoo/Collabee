//
//  ChattingViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import UIKit
import Combine

import SnapKit
import Then
import Common

fileprivate enum Section {
    case main
}

fileprivate enum ChatItem: Hashable {
    case chat(ChatPresentationModel)
}

fileprivate final class DataSource: UITableViewDiffableDataSource<Section, ChatItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .chat(let chatModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.backgroundColor = .bgPrimary
                cell.selectionStyle = .none
                cell.configureCell(chat: chatModel)
                return cell
            }
        }
    }
}

fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ChatItem>

final class DMChattingViewController: BaseViewController {
    
    private lazy var dataSource = DataSource(chatTableView)
    
    private lazy var chatTableView = UITableView().then {
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        $0.backgroundColor = .bgPrimary
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 300
        $0.separatorStyle = .none
    }
    private let chatInputView = ChatInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissAction()
        startObservingKeyboard()
    }
    
    override func configureHierarchy() {
        view.addSubview(chatTableView)
        view.addSubview(chatInputView)
    }
    
    override func configureLayout() {
        
        chatTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        chatInputView.snp.makeConstraints { make in
            make.top.equalTo(chatTableView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
        
    }
    
    override func bindViewModel() {
        chatInputView.chatInputTextView.textPublisher
            .withUnretained(self)
            .sink { owner, text in
                let isEmpty = text.isEmpty
                let sendIcon = isEmpty ? UIImage.disabledSendIcon : UIImage.enabledSendIcon

                owner.chatInputView.sendButton.setImage(sendIcon, for: .normal)
                owner.chatInputView.sendButton.isEnabled = !isEmpty
                owner.chatInputView.placeholderLabel.isHidden = !isEmpty
                owner.chatInputView.sendButton.tintColor = isEmpty ? .brandInactive : .brandMainTheme
                owner.chatInputView.updateTextViewHeight()
            }.store(in: &cancellable)
        
        let chats = [
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "유진영", content: "안녕하세요", sendDate: "11:00 오전", images: ["", "", "", ""]),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "최대성", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요", sendDate: "11:34 오전", images: ["", "", "", "", ""]),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "유진영", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요", sendDate: "12:00 오후", images: ["", "", "", "", ""]),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "최대성", content: "", sendDate: "12:30 오후", images: ["", "", ""]),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "유진영", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요", sendDate: "13:30 오후", images: ["", ""]),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "최대성", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요", sendDate: "14:55 오후", images: []),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "최대성", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요", sendDate: "15:30 오후", images: []),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "유진영", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요 안녕하세요", sendDate: "14:30 오후", images: [""]),
            ChatPresentationModel(id: UUID().uuidString, profileImage: "", senderName: "유진영", content: "안녕하세요 안녕하세요 안녕하세요 안녕하세요. 안녕하세요", sendDate: "14:33 오후", images: [])
        ]
        
        applySnapShot(chats)
    }
    
    private func applySnapShot(_ chats: [ChatPresentationModel]) {
        var snapShot = Snapshot()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(chats.map { ChatItem.chat($0) }, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension DMChattingViewController {
    private func startObservingKeyboard() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: keyboardWillAppear
        )
        
        
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: keyboardWillDisappear
        )

    }
    
    private func keyboardWillAppear(_ notification: Notification) {
        print("")
        print("*** keyboardWillAppear ***")
        
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        
        print("keyboardFrame height : \(keyboardFrame.height)")
        
//
        let height = keyboardFrame.height - 83

        let currentOffset = chatTableView.contentOffset.y
        
        let newOffset = max(currentOffset + height, 0)
        
        print("현재 offset : \(currentOffset)")
        print("새로운 offset : \(newOffset)")
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.chatTableView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
        }
    }
    
    private func keyboardWillDisappear(_ notification: Notification) {
        print("")
        print("*** keyboardWillDisappear ***")
            
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        
        print("keyboardFrame height : \(keyboardFrame.height)")
        
        let keyboardHeight: CGFloat = 336
        
        let height = keyboardHeight - 83
        
        let currentOffset = chatTableView.contentOffset.y
        
        let newOffset = currentOffset - height
        
        print("현재 offset : \(currentOffset)")
        print("새로운 offset : \(newOffset)")
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.chatTableView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
        }
    }
}

#if DEBUG
import SwiftUI

struct DMChattingViewControllerPreview: PreviewProvider {
    static var previews: some View {
        DMChattingViewController().toPreview()
    }
}
#endif
