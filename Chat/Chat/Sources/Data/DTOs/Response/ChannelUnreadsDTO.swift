//
//  ChannelUnreadsDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct ChannelUnreadsDTO: Decodable {
    let channelID: String
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name
        case count
    }
}

extension ChannelUnreadsDTO {
    func toDomain() -> Unreads {
        return Unreads(id: self.channelID, count: self.count)
    }
}
