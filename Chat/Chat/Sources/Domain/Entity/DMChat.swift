//
//  DMChat.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public struct DMChat {
    public let chatID: String
    public let roomID: String
    public let content: String
    public let createdAt: String
    public let files: [String]
    public let sender: Sender
    
    public init(chatID: String, roomID: String, content: String, createdAt: String, files: [String], sender: Sender) {
        self.chatID = chatID
        self.roomID = roomID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.sender = sender
    }
}
