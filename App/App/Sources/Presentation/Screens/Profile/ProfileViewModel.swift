//
//  ProfileViewModel.swift
//  App
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import Combine
import UIKit.UIImage

import User
import Common

final class ProfileViewModel {
    @Injected private var repository: UserRepository
    private var cancellable = Set<AnyCancellable>()
    
    init() {}
    
    func transform(input: Input) -> Output {
        
        let selectedProfileImage = CurrentValueSubject<Data, Never>(Data())
        let originProfileImage = PassthroughSubject<String, Never>()
        let nameSubject = CurrentValueSubject<String, Never>("")
        let isValid = PassthroughSubject<Bool, Never>()
        let isComplete = PassthroughSubject<Bool, Never>()
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ -> AnyPublisher<User, UserError> in
                return owner.repository.fetchMyProfile()
            }
            .withUnretained(self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            } receiveValue: { owner, user in
                nameSubject.send(user.nickname)
                originProfileImage.send(user.profileImage)
            }.store(in: &cancellable)

        
        input.profileImage
            .sink { [weak self] image in
                guard let self else { return }
                
                if let image {
                    selectedProfileImage.send(image.jpegData(compressionQuality: 1)!)
                }
                
            }.store(in: &cancellable)
        
        input.nameText
            .sink { [weak self] name in
                guard let self else { return }
                nameSubject.send(name)
            }.store(in: &cancellable)
        
        input.completeButtonTapped
            .withUnretained(self)
            .flatMap { (owner, _) -> AnyPublisher<User, UserError> in
                let body = ProfileBody(nickname: nameSubject.value, phone: "")
                let merge = Publishers.Merge(owner.repository.updateProfile(body), owner.repository.updateProfileImage(selectedProfileImage.value))
                
                return merge.eraseToAnyPublisher()
            }
            .withUnretained(self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            }, receiveValue: { owner, _ in
                isComplete.send(true)
            })
            .store(in: &cancellable)
        
        Publishers.CombineLatest(input.profileImage, input.nameText)
            .sink { [weak self] image, name in
                guard let self else { return }
                
                let valid = image != nil && !name.isEmpty
                isValid.send(valid)
            }
            .store(in: &cancellable)

        return Output(
            selectedProfileImage: selectedProfileImage.map { UIImage(data: $0) }.eraseToAnyPublisher(),
            originProfileImage: originProfileImage.eraseToAnyPublisher(),
            name: nameSubject.eraseToAnyPublisher(),
            isValid: isValid.eraseToAnyPublisher(),
            isComplete: isComplete.eraseToAnyPublisher()
        )
    }
    
}

extension ProfileViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let profileImage: AnyPublisher<UIImage?, Never>
        let nameText: AnyPublisher<String, Never>
        let completeButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let selectedProfileImage: AnyPublisher<UIImage?, Never>
        let originProfileImage: AnyPublisher<String, Never>
        let name: AnyPublisher<String, Never>
        let isValid: AnyPublisher<Bool, Never>
        let isComplete: AnyPublisher<Bool, Never>
    }
}
