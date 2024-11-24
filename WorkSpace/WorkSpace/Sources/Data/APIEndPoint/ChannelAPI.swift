//
//  ChannelAPI.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import DataSource

enum ChannelAPI {
    case myChannels(_ workspaceID: String)
    case channels(_ workspaceID: String)
    case create(_ workspaceID: String, ChannelBody)
    case channelDetail(_ workspaceID: String, _ channelID: String)
    case deleteChannel(_ workspaceID: String, _ channelID: String)
    case editChannel(_ workspaceID: String, _ channelID: String, ChannelBody)
    case exitChannel(_ workspaceID: String, _ channelID: String)
}

extension ChannelAPI: API {
    
    var path: String {
        switch self {
        case .myChannels(let id):
            return "/v1/workspaces/\(id)/my-channels"
        case .channels(let id), .create(let id, _):
            return "/v1/workspaces/\(id)/channels"
        case .channelDetail(let wsID, let chID), .deleteChannel(let wsID, let chID), .editChannel(let wsID, let chID, _):
            return "/v1/workspaces/\(wsID)/channels/\(chID)"
        case .exitChannel(let wsID, let chID):
            return "/v1/workspaces/\(wsID)/channels/\(chID)/exit"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myChannels, .channels, .channelDetail, .exitChannel:
            return .get
        case .create:
            return .post
        case .deleteChannel:
            return .delete
        case .editChannel:
            return .put
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .myChannels, .channels, .channelDetail, .exitChannel, .deleteChannel:
            return .requestPlain
        case .create(_, let body):
            return .uploadMultipart(body.makeMultipartFomrData())
        case .editChannel(_, _, let body):
            return .uploadMultipart(body.makeMultipartFomrData())
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myChannels, .channels, .channelDetail, .exitChannel, .deleteChannel:
            return nil
        case .create, .editChannel:
            return [
                Header.contentType.rawValue: Header.multipart.rawValue
            ]
        }
    }
    
}
