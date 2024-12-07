//
//  DMRoomPresentationModel.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import Chat
import Common

struct DMRoomPresentationModel: Hashable, Identifiable {
    let id: String
    let name: String
    let profileImageURL: String?
    let lastMessage: String
    let lastDate: String
    let numberOfUnreadMessage: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension DMRoomPresentationModel {
    static func create(_ entity: Chat, _ chatRoom: ChatRoom, numberOfUnreadMessage: Int) -> Self {
        return DMRoomPresentationModel(
            id: entity.roomID,
            name: chatRoom.name,
            profileImageURL: chatRoom.imageURL,
            lastMessage: entity.content,
            lastDate: entity.createdAt.toChatTime(),
            numberOfUnreadMessage: numberOfUnreadMessage
        )
    }
}
