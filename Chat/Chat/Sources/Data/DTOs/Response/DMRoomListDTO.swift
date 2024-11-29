//
//  DMRoomListDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

struct DMRoomListDTO: Decodable {
    let roomID: String
    let createdAt: String
    let user: UserDTO
}
