//
//  UserRepository.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import Combine

public protocol UserRepository {
    func fetchMyProfile() -> AnyPublisher<User, UserError>
    func updateProfile(_ body: ProfileBody) -> AnyPublisher<User, UserError>
    func updateProfileImage(_ imageData: Data) -> AnyPublisher<User, UserError>
    func fetchMemberProfile(_ userID: String) -> AnyPublisher<User, UserError>
}
