//
//  ChannelChatDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct ChannelChattingDTO: Decodable {
    let channelID: String
    let channelName: String
    let chatID: Int
    let content: String
    let createdAt: String
    let files: [String]
    let user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
}
