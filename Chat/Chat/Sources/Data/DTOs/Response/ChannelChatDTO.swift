//
//  ChannelChatDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct ChannelChatDTO: Decodable {
    let channelID: String
    let chatID: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case chatID = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
}

extension ChannelChatDTO {
    func toDomain() -> Chat {
        return Chat(id: self.chatID,
                    roomID: self.channelID,
                    content: self.content,
                    createdAt: self.createdAt,
                    files: self.files,
                    sender: self.user.toDomain())
    }
}
