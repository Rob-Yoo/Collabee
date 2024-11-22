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
    
    private var profileImageView = RoundedImageView().then {
        let placeHolder = UIImage.profilePlaceholder
        let size = CGSize(width: 40, height: 40)
        
        $0.isUserInteractionEnabled = true
        $0.image = placeHolder.resizeImage(size)
        $0.frame = CGRect(origin: .zero, size: size)
    }
    
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
    
    private var createButton = RoundedTextButton(Constant.Literal.ButtonText.createWorkspace).then {
        $0.backgroundColor = .brandMainTheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationRightBarButtonItem()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(bgImageView)
        self.view.addSubview(createButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
                .offset(30)
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
    
    override func bindViewModel() {
        let tapGR = UITapGestureRecognizer()
        
        profileImageView.addGestureRecognizer(tapGR)
        
        tapGR.tapPublisher
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                print("HI")
            }
            .store(in: &cancellable)
        
        createButton.tap
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                let sheetVC = CreateWorkspaceViewController(navTitle: Constant.Literal.CreateWorkSpace.navTitle)
                presentBottomSheet(sheetVC)
                
            }.store(in: &cancellable)
        
    }
    
    private func configureNavigationRightBarButtonItem() {
        let barButton = UIBarButtonItem(customView: profileImageView)
        self.navigationItem.rightBarButtonItem = barButton
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
