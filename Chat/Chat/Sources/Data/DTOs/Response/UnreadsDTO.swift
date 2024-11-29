//
//  UnreadsDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct UnreadsDTO: Decodable {
    let channelID: String
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name
        case count
    }
}
