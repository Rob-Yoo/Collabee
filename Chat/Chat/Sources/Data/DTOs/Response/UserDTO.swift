//
//  UserDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct UserDTO: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
    }
}
