//
//  DMChatDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct DMChatDTO: Decodable {
    let roomID: String
    let dmID: String
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

extension DMChatDTO {
    func toDomain() -> Chat {
        return Chat(id: self.dmID,
                    roomID: self.roomID,
                    content: self.content,
                    createdAt: self.createdAt,
                    files: self.files,
                    sender: self.user.toDomain())
    }
}
