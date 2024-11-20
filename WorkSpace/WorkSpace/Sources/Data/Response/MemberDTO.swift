//
//  MemberDTO.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct MemberDTO: Decodable {
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
