//
//  ChannelChatAPI.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/28/24.
//

import DataSource

enum ChannelChatAPI {
    case chatList(_ wsID: String, _ chID: String, _ cursorDate: String)
    case sendChat(_ wsID: String, _ chID: String, ChatBody)
    case unreads(_ wsID: String, _ chID: String, _ after: String)
}

extension ChannelChatAPI: API {
    var path: String {
        switch self {
        case .chatList(let wsID, let chID, _):
            return "/v1/workspaces/\(wsID)/channels/\(chID)/chats"
        case .sendChat(let wsID, let chID, _):
            return "/v1/workspaces/\(wsID)/channels/\(chID)/chats"
        case .unreads(let wsID, let chID, _):
            return "/v1/workspaces/\(wsID)/channels/\(chID)/unreads"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .chatList:
            return .get
        case .sendChat:
            return .post
        case .unreads:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .chatList(_, _, let cursorDate):
            return .requestQueryParameters(parameters: ["cursor_date": cursorDate])
        case .sendChat(_, _, let body):
            return .uploadMultipart(body.makeMultipartFormData())
        case .unreads(_, _, let after):
            return .requestQueryParameters(parameters: ["after": after])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .chatList:
            return nil
        case .sendChat:
            return [
                Header.contentType.rawValue: Header.multipart.rawValue
            ]
        case .unreads:
            return nil
        }
    }
}
