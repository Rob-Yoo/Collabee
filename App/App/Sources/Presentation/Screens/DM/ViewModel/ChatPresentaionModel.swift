//
//  ChatPresentaionModel.swift
//  App
//
//  Created by Jinyoung Yoo on 12/2/24.
//

import Chat

struct ChatPresentationModel: Hashable, Identifiable {
    let id: String
    let profileImage: String?
    let senderName: String
    let content: String
    let sendDate: String
    let images: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ChatPresentationModel {
    static func create(_ entity: Chat) -> ChatPresentationModel {
        return ChatPresentationModel(id: entity.id,
                                     profileImage: entity.sender.profileImage,
                                     senderName: entity.sender.name,
                                     content: entity.content,
                                     sendDate: entity.createdAt,
                                     images: entity.files)
    }
}
