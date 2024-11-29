//
//  DMRoom.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public struct DMRoom {
    public let roomID: String
    public let createdAt: String
    public let opponent: Sender
    
    public init(roomID: String, createdAt: String, opponent: Sender) {
        self.roomID = roomID
        self.createdAt = createdAt
        self.opponent = opponent
    }
    
}
