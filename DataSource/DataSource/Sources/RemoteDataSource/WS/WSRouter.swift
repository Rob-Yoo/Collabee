//
//  WSRouter.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/28/24.
//

public enum WSRouter {
    case channel(_ channelID: String)
    case dm(_ roomId: String)
    
    public var event: String {
        switch self {
        case .channel:
            return "channel"
        case .dm:
            return "dm"
        }
    }
    
    public var nameSpace: String {
        switch self {
        case .channel(let channelID):
            return "/ws-channel-\(channelID)"
        case .dm(let roomID):
            return "/ws-dm-\(roomID)"
        }
    }
}
