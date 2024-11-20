//
//  WorkSpaceAPI.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Foundation

import DataSource

enum WorkSpaceAPI {
    case workspaceList
    case workspaceContent(_ workspaceID: String)
    case createWorkSpace(CreateWorkspaceBody)
    case editWorkSpace(_ workspaceID: String, _ body: EditWorkspaceBody)
    case deleteWorkSpace(_ workspaceID: String)
}

extension WorkSpaceAPI: API {

    var path: String {
        switch self {
        case .workspaceList, .createWorkSpace:
            return "/v1/workspaces"
        case .workspaceContent(let workspaceID),
                .editWorkSpace(let workspaceID, _),
                .deleteWorkSpace(let workspaceID):
            return "/v1/workspaces/\(workspaceID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .workspaceList, .workspaceContent:
            return .get
        case .createWorkSpace:
            return .post
        case .editWorkSpace:
            return .put
        case .deleteWorkSpace:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .workspaceList, .workspaceContent:
            return .requestPlain
        case .createWorkSpace(let body):
            return .uploadMultipart(body.makeMultipartFomrData())
        case .editWorkSpace(_, let body):
            return .uploadMultipart(body.makeMultipartFomrData())
        case .deleteWorkSpace:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .workspaceList, .workspaceContent, .deleteWorkSpace:
            return nil
        case .createWorkSpace, .editWorkSpace:
            return [
                Header.contentType.rawValue: Header.multipart.rawValue
            ]
        }
    }
    
}
