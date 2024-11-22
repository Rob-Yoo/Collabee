//
//  OnboardingViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import UIKit
import Combine

import Authorization
import Common

import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    
    private let useCase: AuthUseCase
    private var cancellable = Set<AnyCancellable>()
    
    public init(useCase: AuthUseCase) {
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var emailLoginButton = RoundedTextButton(Constant.Literal.Onboarding.emailLogin).then {
        $0.backgroundColor = .brandMainTheme
        $0.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
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
        self.view.addSubview(emailLoginButton)
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
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(55)
            make.height.equalTo(44)
        }
    }
    
    @objc private func appleLoginButtonTapped() {
        useCase.login(.apple(self.view.window!))
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("📌 에러 발생: " + error.localizedDescription)
                }
            } receiveValue: { _ in
                NotificationCenter.default.post(name: .ChangeWindowScene, object: nil)
            }.store(in: &cancellable)

    }
    
    @objc private func kakaoLoginButtonTapped() {
        useCase.login(.kakao)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("📌 에러 발생: " + error.localizedDescription)
                }
            } receiveValue: { _ in
                NotificationCenter.default.post(name: .ChangeWindowScene, object: nil)
            }.store(in: &cancellable)
    }
    
    @objc
    private func emailLoginButtonTapped() {
        useCase.login(.email)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("📌 에러 발생: " + error.localizedDescription)
                }
            } receiveValue: { _ in
                NotificationCenter.default.post(name: .ChangeWindowScene, object: nil)
            }.store(in: &cancellable)

    }
}
//
//#if DEBUG
//import SwiftUI
//
//struct PreView: PreviewProvider {
//    static var previews: some View {
//        OnboardingViewController().toPreview()
//    }
//}
//#endif
