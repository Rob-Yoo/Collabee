//
//  ChannelChat.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public struct ChannelChat {
    public let chatID: String
    public let channelID: String
    public let channelName: String
    public let content: String
    public let createdAt: String
    public let files: [String]
    public let sender: Sender
    
    public init(chatID: String, channelID: String, channelName: String, content: String, createdAt: String, files: [String], sender: Sender) {
        self.chatID = chatID
        self.channelID = channelID
        self.channelName = channelName
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.sender = sender
    }
    
}
