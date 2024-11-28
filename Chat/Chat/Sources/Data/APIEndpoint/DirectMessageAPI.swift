//
//  DirectMessageAPI.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/28/24.
//

import DataSource

struct EnterRoomBody: Encodable {
    let opponentID: String
    
    enum CodingKeys: String, CodingKey {
        case opponentID = "opponent_id"
    }
    
    func makeMultiPartFormData() -> [MultipartFormData] { return [] }
}

enum DirectMessageAPI {
    case enterRoom(_ wsID: String, EnterRoomBody)
    case dmRooms(_ wsID: String)
    case sendDM(_ wsID: String, _ roomID: String, ChatBody)
    case dms(_ wsID: String, _ roomID: String, _ cursorDate: String)
    case unreads(_ wsID: String, _ roomID: String, _ after: String)
}

extension DirectMessageAPI: API {
    var path: String {
        switch self {
        case .enterRoom(let wsID, _):
            return "/v1/workspaces/\(wsID)/dms"
        case .dmRooms(let wsID):
            return "/v1/workspaces/\(wsID)/dms"
        case .sendDM(let wsID, let roomID, _):
            return "/v1/workspaces/\(wsID)/dms/\(roomID)/chats"
        case .dms(let wsID, let roomID, _):
            return "/v1/workspaces/\(wsID)/dms/\(roomID)/chats"
        case .unreads(let wsID, let roomID, _):
            return "/v1/workspaces/\(wsID)/dms/\(roomID)/unreads"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .enterRoom:
            return .post
        case .dmRooms:
            return .get
        case .sendDM:
            return .post
        case .dms:
            return .get
        case .unreads:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .enterRoom(_, let enterRoomBody):
            return .requestWithEncodableBody(enterRoomBody)
        case .dmRooms:
            return .requestPlain
        case .sendDM(_, _, let chatBody):
            return .uploadMultipart(chatBody.makeMultipartFormData())
        case .dms(_, _, let cursorDate):
            return .requestQueryParameters(parameters: ["cursor_date": cursorDate])
        case .unreads(_, _, let after):
            return .requestQueryParameters(parameters: ["after": after])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .enterRoom:
            return [
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .dmRooms:
            return nil
        case .sendDM:
            return [
                Header.contentType.rawValue: Header.multipart.rawValue
            ]
        case .dms:
            return nil
        case .unreads:
            return nil
        }
    }
}

