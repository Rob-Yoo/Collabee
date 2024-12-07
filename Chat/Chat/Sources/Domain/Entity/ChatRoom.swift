//
//  ChatRoom.swift
//  Chat
//
//  Created by Jinyoung Yoo on 12/2/24.
//

public struct ChatRoom: Hashable {
    public let roomID: String
    public let name: String
    public let imageURL: String?
    
    public init(roomID: String, name: String, imageURL: String?) {
        self.roomID = roomID
        self.name = name
        self.imageURL = imageURL
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(roomID)
    }
}
