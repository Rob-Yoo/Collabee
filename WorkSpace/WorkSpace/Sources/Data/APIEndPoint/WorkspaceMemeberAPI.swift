//
//  WorkspaceMemeberAPI.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import DataSource

enum WorkspaceMemeberAPI {
    case invite(_ workspaceID: String, InviteBody)
    case memberList(_ workspaceID: String)
    case memberInfo(_ workspaceID: String, _ userID: String)
    case transferOwnership(_ workspaceID: String, TransferOwnershipBody)
    case exit(_ workspaceID: String)
}

extension WorkspaceMemeberAPI: API {
    var path: String {
        switch self {
        case .invite(let id, _), .memberList(let id):
            return "/v1/workspaces/\(id)/members"
        case .memberInfo(let workspaceID, let useID):
            return "/v1/workspaces/\(workspaceID)/members/\(useID)"
        case .transferOwnership(let id, _):
            return "/v1/workspaces/\(id)/transfer/ownership"
        case .exit(let id):
            return "/v1/workspaces/\(id)/exit"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .invite:
            return .post
        case .memberList, .memberInfo:
            return .get
        case .transferOwnership:
            return .put
        case .exit:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .invite(_, let body):
            return .requestWithEncodableBody(body)
        case .memberList, .memberInfo, .exit:
            return .requestPlain
        case .transferOwnership(_, let body):
            return .requestWithEncodableBody(body)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .invite, .transferOwnership:
            return [
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .memberList, .memberInfo, .exit:
            return nil
        }
    }
    
}
