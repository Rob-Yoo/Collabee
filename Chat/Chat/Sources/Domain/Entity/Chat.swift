//
//  ChannelChat.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public struct Chat: Hashable {

    public let id: String
    public let roomID: String
    public let content: String
    public let createdAt: String
    public let files: [String]
    public let sender: Sender
    
    public init(id: String, roomID: String, content: String, createdAt: String, files: [String], sender: Sender) {
        self.id = id
        self.roomID = roomID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.sender = sender
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
 
    public static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
}
