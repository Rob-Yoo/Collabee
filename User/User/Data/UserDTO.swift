//
//  UserDTO.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import Foundation

struct UserDTO: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
    }
}

extension UserDTO {
    func toDomain() -> User {
        return User(userID: self.userID,
                    nickname: self.nickname,
                    profileImage: self.profileImage)
    }
}
