//
//  ChannelContentDTO.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct ChannelContentDTO: Decodable {
    let channelID: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerID: String
    let createdAt: Date
    let channelMembers: [MemberDTO]

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name
        case description
        case coverImage
        case ownerID = "owner_id"
        case createdAt
        case channelMembers
    }
}
