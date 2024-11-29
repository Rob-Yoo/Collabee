//
//  DMUnreadsDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct DMUnreadsDTO: Decodable {
    let roomID: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case count
    }
}
