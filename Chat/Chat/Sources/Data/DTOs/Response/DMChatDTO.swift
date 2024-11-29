//
//  DMChatDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct DMChatDTO: Decodable {
    let roomID: String
    let dmID: Int
    let content: String
    let createdAt: String
    let files: [String]
    let user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case dmID = "dm_id"
        case content
        case createdAt
        case files
        case user
    }
}
