//
//  SheetPresentationViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import UIKit

import SnapKit
import Then

class SheetPresentationViewController: BaseViewController {
    
    var navTitle: String
    
    private lazy var titleLabel = UILabel().then {
        $0.text = navTitle
        $0.font = .bold17
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var titleContainerView = UIView().then {
        $0.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(3)
        }
    }
    
    private let cancelButton = UIButton().then {
        $0.setImage(.xIcon, for: .normal)
        $0.tintColor = .black
    }
    
    init(navTitle: String) {
        self.navTitle = navTitle
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.titleView = titleContainerView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        cancelButton.tap
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }.store(in: &cancellable)
    }
}
