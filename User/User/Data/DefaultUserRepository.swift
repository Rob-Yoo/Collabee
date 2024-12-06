//
//  UserRepository.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import Combine

import DataSource
import Common

public final class DefaultUserRepository: UserRepository {
    
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    public func fetchMyProfile() -> AnyPublisher<User, UserError> {
        return networkProvider.request(UserAPI.getMyProfile, UserDTO.self, .withToken)
            .map { $0.toDomain() }
            .mapError { _ in UserError.fetchProfileFailure }
            .eraseToAnyPublisher()
    }
    
    public func updateProfile(_ body: ProfileBody) -> AnyPublisher<User, UserError> {
        return networkProvider.request(UserAPI.editMyProfile(body), UserDTO.self, .withToken)
            .map { $0.toDomain() }
            .mapError { _ in UserError.editFailure }
            .eraseToAnyPublisher()
    }
    
    public func updateProfileImage(_ imageData: Data) -> AnyPublisher<User, UserError> {
        let formData = MultipartFormData(data: imageData, name: "image", fileName: "ProfileImage", mimeType: "image/jpeg")
        
        return networkProvider.request(UserAPI.editMyProfileImage(formData), UserDTO.self, .withToken)
            .map { $0.toDomain() }
            .mapError { _ in UserError.editFailure }
            .eraseToAnyPublisher()
    }
    
    public func fetchMemberProfile(_ userID: String) -> AnyPublisher<User, UserError> {
        return networkProvider.request(UserAPI.getMemberProfile(userID), UserDTO.self, .withToken)
            .map { $0.toDomain() }
            .mapError { _ in UserError.fetchProfileFailure }
            .eraseToAnyPublisher()
    }
    
}
