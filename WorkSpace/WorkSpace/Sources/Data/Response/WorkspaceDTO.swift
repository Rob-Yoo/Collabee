//
//  WorkspacesDTO.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct WorkspaceDTO: Decodable {
    let workspaceID: String
    let name: String
    let description: String?
    let coverImage: String
    let ownerID: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name
        case description
        case coverImage
        case ownerID = "owner_id"
        case createdAt
    }
}

extension WorkspaceDTO {
    func toDomain() -> Workspace {
        return Workspace(
            id: self.workspaceID,
            name: self.name,
            createdAt: self.createdAt,
            ownerID: self.ownerID,
            image: self.coverImage
        )
    }
}
