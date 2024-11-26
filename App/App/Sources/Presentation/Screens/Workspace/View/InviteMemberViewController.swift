//
//  InviteMemberViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import UIKit
import Combine

import SnapKit
import Then

import WorkSpace
import Common

final class InviteMemberViewController: SheetPresentationViewController {
    
    @Injected private var repostiory: WorkspaceMemberRepository
    private var email: String = ""
    private var workspaceID: String
    
    init(workspaceID: String, navTitle: String) {
        self.workspaceID = workspaceID
        super.init(navTitle: navTitle)
    }
    
    private let emailLabel = UILabel().then {
        $0.text = Constant.Literal.InviteMember.emailTextField
        $0.font = .bold14
        $0.textColor = .black
    }
    
    private let emailTextField = UITextField().then {
        $0.placeholder = Constant.Literal.InviteMember.emailTextFieldPlaceholder
        $0.font = .regular13
        $0.textColor = .black
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
    }
    
    private let inviteButton = RoundedTextButton(Constant.Literal.ButtonText.invite).then {
        $0.backgroundColor = .brandInactive
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgPrimary
        addKeyboardDismissAction()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(inviteButton)
    }
    
    override func configureLayout() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        inviteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    override func bindViewModel() {
        emailTextField.textPublisher.orEmpty
            .withUnretained(self)
            .sink { owner, email in
                owner.email = email
                owner.inviteButton.isEnabled = !email.isEmpty
                owner.inviteButton.backgroundColor = email.isEmpty ? UIColor.brandInactive : UIColor.brandMainTheme
            }.store(in: &cancellable)
        
        
        inviteButton.tap
            .withUnretained(self)
            .flatMap { (owner, _) -> AnyPublisher<Member, WorkspaceMemberError> in
                owner.repostiory.invite(owner.workspaceID, InviteBody(email: owner.email))
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.errorDescription ?? "")
                }
            } receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            }.store(in: &cancellable)

    }
}

#if DEBUG
import SwiftUI

struct InviteMemberViewControllerPreView: PreviewProvider {
    static var previews: some View {
        InviteMemberViewController(workspaceID: "mock", navTitle: "팀원 초대").toPreview()
    }
}
#endif
