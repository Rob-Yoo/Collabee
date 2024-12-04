//
//  ChatObject.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Common

import RealmSwift

class ChatObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var chatRoom: ChatRoomObject?
    @Persisted var sender: SenderObject?
    @Persisted var content: String
    @Persisted(indexed: true) var createdAt: Date
    @Persisted var files: List<String>
}

extension ChatObject {
    convenience init(_ entity: Chat) {
        let fileList = List<String>()

        self.init()
        self.id = entity.id
        self.content = entity.content
        self.createdAt = entity.createdAt.toServerDate()
        self.chatRoom = ChatRoomObject(id: entity.roomID)
        self.sender = SenderObject(entity.sender)
        fileList.append(objectsIn: entity.files)
        self.files = fileList
    }
    
    func toDomain() -> Chat {
        return Chat(id: self.id,
                    roomID: self.chatRoom?.id ?? "",
                    content: self.content,
                    createdAt: self.createdAt.toServerDateStr(),
                    files: self.files.map { $0 },
                    sender: self.sender?.toDomain() ?? Sender(id: "", name: "", email: "", profileImage: nil))
    }
}
