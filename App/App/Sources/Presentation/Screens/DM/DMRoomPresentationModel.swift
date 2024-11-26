//
//  DMRoomPresentationModel.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import Foundation

struct DMRoomPresentationModel: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let profileImageURL: String
    let lastMessage: String
    let lastDate: String
    let numberOfUnreadMessage: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
