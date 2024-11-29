//
//  DMRoomDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct DMRoomDTO: Decodable {
    let roomID: String
    let createdAt: String
    let user: UserDTO
}

extension DMRoomDTO {
    func toDomain() -> DMRoom {
        return DMRoom(roomID: self.roomID,
                      createdAt: self.createdAt,
                      opponent: self.user)
    }
}
