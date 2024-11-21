//
//  ChannelDTO.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct ChannelDTO: Decodable {
    let channelID: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerID: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name
        case description
        case coverImage
        case ownerID = "owner_id"
        case createdAt
    }
}

extension ChannelDTO {
    func toDomain() -> Channel {
        return Channel(
            id: self.channelID,
            name: self.name,
            description: self.description,
            createdAt: self.createdAt,
            ownerID: self.ownerID
        )
    }
}
