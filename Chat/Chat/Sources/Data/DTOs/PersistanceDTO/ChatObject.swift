//
//  ChatObject.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Common

import RealmSwift

final class ChatObject: EmbeddedObject {
    @Persisted var id: String
    @Persisted var sender: SenderObject?
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted(originProperty: "chats") var chatRoom: LinkingObjects<ChatRoomObject>
}

extension ChatObject {
    convenience init(_ entity: Chat) {
        let fileList = List<String>()
        
        fileList.append(objectsIn: entity.files)
        self.init()
        self.id = entity.id
        self.content = entity.content
        self.createdAt = entity.createdAt.toServerDate()
        self.files = fileList
    }
    
    func toDomain() -> Chat {
        return Chat(
            id: self.id,
            roomID: self.chatRoom.first?.id ?? "",
            content: self.content,
            createdAt: self.createdAt.toServerDateStr(),
            files: self.files.map { $0 },
            sender: self.sender?.toDomain() ?? Sender(id: "", name: "", email: "", profileImage: nil)
        )
    }
}
