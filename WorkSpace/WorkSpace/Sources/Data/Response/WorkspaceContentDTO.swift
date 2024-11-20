//
//  WorkspaceContentDTO.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct WorkspaceContentDTO: Decodable {
    let workspaceID: String
    let name: String
    let description: String
    let coverImage: String
    let ownerID: String
    let createdAt: Date
    let channels: [ChannelDTO]
    let workspaceMembers: [MemberDTO]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name
        case description
        case coverImage
        case ownerID = "owner_id"
        case createdAt
        case channels
        case workspaceMembers
    }
}
