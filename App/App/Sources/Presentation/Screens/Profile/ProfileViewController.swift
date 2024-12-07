//
//  ProfileViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import UIKit
import Combine
import PhotosUI

import Common

import SnapKit
import Then

final class ProfileViewController: SheetPresentationViewController {
    
    private let vm = ProfileViewModel()
    
    private var profileImage = PassthroughSubject<UIImage?, Never>()
    var onDismiss: ((UIImage?) -> Void)?
    
    private var photoPicker: PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }
    
    private let cameraImageView = UIImageView().then {
        $0.image = .camera
        $0.contentMode = .scaleAspectFill
    }
    
    private let profileImageView = RoundedImageView().then {
        $0.image = .sesacBot
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var coverContainerView = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 15
        
        $0.addSubview(profileImageView)
        $0.addSubview(cameraImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(5)
            make.size.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private let nameLabel = UILabel().then {
        $0.text = Constant.Literal.Profile.nameTextField
        $0.font = .bold14
        $0.textColor = .black
    }
    
    private let nameTextField = UITextField().then {
        $0.placeholder = Constant.Literal.Profile.nameTextFieldPlaceHolder
        $0.font = .regular13
        $0.textColor = .black
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
    }
    
    private let completeButton = RoundedTextButton(Constant.Literal.ButtonText.complete).then {
        $0.backgroundColor = .brandInactive
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissAction()
        view.backgroundColor = .bgPrimary
    }
    
    override func configureHierarchy() {
        self.view.addSubview(coverContainerView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(completeButton)
    }
    
    override func configureLayout() {
        coverContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(coverContainerView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    override func bindViewModel() {
        let input = ProfileViewModel.Input(viewDidLoad: viewDidLoadPublisher,
                                           profileImage: profileImage.eraseToAnyPublisher(),
                                           nameText: nameTextField.textPublisher.orEmpty,
                                           completeButtonTapped: completeButton.tap)
        let tapGR = UITapGestureRecognizer().then {
            coverContainerView.addGestureRecognizer($0)
        }
        let output = vm.transform(input: input)
        
        tapGR.tapPublisher
            .withUnretained(self)
            .sink { owner, _ in
                let ph = owner.photoPicker
                
                ph.delegate = owner
                ph.modalPresentationStyle = .fullScreen
                owner.present(ph, animated: true)
                
            }
            .store(in: &cancellable)
        
        output.originProfileImage
            .withUnretained(self)
            .sink { owner, url in
                owner.profileImageView.setImage(imageURL: url, placeHolder: .profilePlaceholder, size: CGSize(width: 70, height: 70))
            }.store(in: &cancellable)
        
        output.name
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameTextField)
            .store(in: &cancellable)
        
        output.selectedProfileImage
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: profileImageView)
            .store(in: &cancellable)
        
        output.isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self else { return }
                
                completeButton.isEnabled = isValid
                completeButton.backgroundColor = isValid ? .brandMainTheme : .brandInactive
            }
            .store(in: &cancellable)
        
        output.isComplete
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (owner, flag) in
                if flag {
                    owner.onDismiss?(owner.profileImageView.image)
                    owner.dismiss(animated: true)
                }
            }.store(in: &cancellable)
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {

            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                
                guard let self else { return }
                
                if let image = object as? UIImage {
                    let downsampledImage = UIImage.downsample(image.jpegData(compressionQuality: 1.0)!, CGSize(width: Constant.Dimension.screenWidth, height: Constant.Dimension.screenWidth))
                    profileImage.send(downsampledImage)
                } else {
                    print("Cannot Data")
                }
            }
            
        }
        
        dismiss(animated: true)
    }
}
