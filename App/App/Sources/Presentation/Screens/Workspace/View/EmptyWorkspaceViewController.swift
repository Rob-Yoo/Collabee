//
//  WorkspaceViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class EmptyWorkspaceViewController: BaseViewController {
    
    private var titleLabel = UILabel().then {
        $0.text = Constant.Literal.HomeEmpty.title
        $0.font = .bold22
        $0.textColor = .black
    }
    
    private var subtitleLabel = UILabel().then {
        $0.text = Constant.Literal.HomeEmpty.subtitle
        $0.font = .regular13
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private var bgImageView = UIImageView().then {
        $0.image = .workspaceEmpty
        $0.contentMode = .scaleAspectFill
    }
    
    private var createButton = RoundedTextButton(Constant.Literal.ButtonText.createWorkspace)
    
    override func configureHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(bgImageView)
        self.view.addSubview(createButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
                .offset(20)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(20)
            make.centerX.equalToSuperview()
        }
        
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
                .offset(-20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
    }
    
    private func configureNavigationRightBarButtonItem() {
        let size = self.navigationController?.navigationBar.frame.height ?? 44
        let profileImageView = RoundedImageView().then {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .black
 /*           $0.image = .profile0.resizeImage(size: CGSize(width: size, height: size))*/ // BarButtonItem에 넣을 땐 Resizing 필수?!
            $0.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        }
        let barButton = UIBarButtonItem(customView: profileImageView)
        let tapGR = UITapGestureRecognizer()
        
        self.navigationItem.rightBarButtonItem = barButton
        profileImageView.addGestureRecognizer(tapGR)
        
        tapGR.tapPublisher
            .sink { _ in
                print("HI")
            }
            .store(in: &cancellable)
    }
}


#if DEBUG
import SwiftUI

struct EmptyWorkspaceViewControllerPreview: PreviewProvider {
    static var previews: some View {
        EmptyWorkspaceViewController().toPreview()
    }
}
#endif
