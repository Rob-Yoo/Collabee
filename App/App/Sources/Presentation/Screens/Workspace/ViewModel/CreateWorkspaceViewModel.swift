//
//  CreateWorkspaceViewModel.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine
import UIKit.UIImage

import WorkSpace
import Common

final class CreateWorkspaceViewModel {

    @Injected private var repository: WorkspaceRepository
    private var cancellable = Set<AnyCancellable>()
    
    private var requestBodyBuilder = CreateWorkSpaceBodyBuilder()
    
    init() {}
    
    func transform(input: Input) -> Output {
        
        let selectedCoverImage = PassthroughSubject<UIImage, Never>()
        let isValid = PassthroughSubject<Bool, Never>()
        let isComplete = PassthroughSubject<Bool, Never>()
        
        input.coverImage
            .sink { [weak self] image in
                guard let self else { return }
                
                if let image {
                    selectedCoverImage.send(image)
                    requestBodyBuilder.image(image.jpegData(compressionQuality: 1.0)!)
                }
                
            }.store(in: &cancellable)
        
        input.nameText
            .sink { [weak self] name in
                guard let self else { return }
                requestBodyBuilder.name(name)
            }.store(in: &cancellable)
        
        input.descriptionText
            .sink { [weak self] description in
                guard let self else { return }
                requestBodyBuilder.description(description)
            }.store(in: &cancellable)
        
        input.completeButtonTapped
            .withUnretained(self)
            .flatMap { (owner, _) -> AnyPublisher<Workspace, WorkspaceError> in
                let body = owner.requestBodyBuilder.build()
                return owner.repository.create(body)
            }
            .withUnretained(self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.errorDescription ?? "")
                }
            }, receiveValue: { owner, res in
                owner.repository.saveWorkspaceID(res.id)
                isComplete.send(true)
            })
            .store(in: &cancellable)
        
        Publishers.CombineLatest(input.coverImage, input.nameText)
            .sink { [weak self] image, name in
                guard let self else { return }
                
                let valid = image != nil && !name.isEmpty
                isValid.send(valid)
            }
            .store(in: &cancellable)

        return Output(
            selectedCoverImage: selectedCoverImage,
            isValid: isValid,
            isComplete: isComplete
        )
    }
}

extension CreateWorkspaceViewModel {

    struct Input {
        let coverImage: AnyPublisher<UIImage?, Never>
        let nameText: AnyPublisher<String, Never>
        let descriptionText: AnyPublisher<String, Never>
        let completeButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let selectedCoverImage: PassthroughSubject<UIImage, Never>
        let isValid: PassthroughSubject<Bool, Never>
        let isComplete: PassthroughSubject<Bool, Never>
    }
}
