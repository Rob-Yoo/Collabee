//
//  ChatRoomDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 12/2/24.
//

import Foundation

struct ChatRoomDTO: Decodable {
    let roomID: String
    let user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case user
    }
}

extension ChatRoomDTO {
    func toDomain() -> ChatRoom {
        return ChatRoom(roomID: self.roomID,
                        name: self.user.nickname,
                        imageURL: user.profileImage)
    }
}
