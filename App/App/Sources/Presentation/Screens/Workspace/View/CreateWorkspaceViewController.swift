//
//  CreateWorkspaceViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit
import Combine
import PhotosUI

import SnapKit
import Then

final class CreateWorkspaceViewController: SheetPresentationViewController {

    private var coverImage = PassthroughSubject<UIImage?, Never>()
    private let vm = CreateWorkspaceViewModel()
    var onDismiss: (() -> Void)?
    
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
    
    private let coverImageView = RoundedImageView().then {
        $0.image = .sesacBot
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var coverContainerView = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 15
        
        $0.addSubview(coverImageView)
        $0.addSubview(cameraImageView)
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(5)
            make.size.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private let nameLabel = UILabel().then {
        $0.text = Constant.Literal.CreateWorkSpace.nameTextField
        $0.font = .bold14
        $0.textColor = .black
    }
    
    private let nameTextField = UITextField().then {
        $0.placeholder = Constant.Literal.CreateWorkSpace.nameTextFieldPlaceHolder
        $0.font = .regular13
        $0.textColor = .black
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = Constant.Literal.CreateWorkSpace.descriptionTextField
        $0.font = .bold14
        $0.textColor = .black
    }
    
    private let descriptionTextField = UITextField().then {
        $0.placeholder = Constant.Literal.CreateWorkSpace.descriptionTextFieldPlaceHolder
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
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(descriptionTextField)
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
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    //MARK: - Bind ViewModel
    override func bindViewModel() {
        let input = CreateWorkspaceViewModel.Input(
            coverImage: coverImage.eraseToAnyPublisher(),
            nameText: nameTextField.textPublisher.orEmpty,
            descriptionText: descriptionTextField.textPublisher.orEmpty,
            completeButtonTapped: completeButton.tap
        )
        
        let output = vm.transform(input: input)
        let tapGR = UITapGestureRecognizer()
        
        coverContainerView.addGestureRecognizer(tapGR)
        
        tapGR.tapPublisher
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                let ph = photoPicker
                
                ph.delegate = self
                ph.modalPresentationStyle = .fullScreen
                present(ph, animated: true)
                
            }
            .store(in: &cancellable)
        
        output.selectedCoverImage
            .receive(on: DispatchQueue.main)
            .map { $0 }
            .assign(to: \.image, on: coverImageView)
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
                    owner.onDismiss?()
                    owner.dismiss(animated: true)
                }
            }.store(in: &cancellable)
    }
    
}

//MARK: - PHPickerViewDelegate
extension CreateWorkspaceViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {

            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                
                guard let self else { return }
                
                if let image = object as? UIImage {
                    let downsampledImage = UIImage.downsample(image.jpegData(compressionQuality: 1.0)!, CGSize(width: 200, height: 200))
                    coverImage.send(downsampledImage)
                } else {
                    print("Cannot Data")
                }
            }
            
        }
        
        dismiss(animated: true)
    }
    
}

#if DEBUG
import SwiftUI

struct CreateWorkspaceViewControllerPreView: PreviewProvider {
    static var previews: some View {
        CreateWorkspaceViewController(navTitle: "워크스페이스 생성").toPreview()
    }
}
#endif
