//
//  OnboardingViewController.swift
//  Feature
//
//  Created by Jinyoung Yoo on 11/3/24.
//

import UIKit
import SnapKit
import Then
import Common

public final class OnboardingViewController: UIViewController {
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.textAlignment = .center
        $0.font = .bold22
        $0.text = Constant.Literal.Onboarding.description
        $0.numberOfLines = 2
    }
    
    private let imageView = UIImageView().then {
        $0.image = .onboarding
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var appleLoginButton = UIButton().then {
        $0.setImage(.appleLoginButton, for: .normal)
        $0.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.setImage(.kakaoLoginButton, for: .normal)
        $0.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureHierarchy() {
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(imageView)
        self.view.addSubview(appleLoginButton)
        self.view.addSubview(kakaoLoginButton)
    }
    
    private func configureLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    @objc private func appleLoginButtonTapped() {
        let appleAuth = AppleOAuth(presentationAnchor: view.window!)
        
        AuthManager.shared.login(appleAuth)
    }
    
    @objc private func kakaoLoginButtonTapped() {
        let kakaoAuth = KakaoOAuth()
        
        AuthManager.shared.login(kakaoAuth)
    }
    
}

#if DEBUG
import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        OnboardingViewController().toPreview()
    }
}
#endif
