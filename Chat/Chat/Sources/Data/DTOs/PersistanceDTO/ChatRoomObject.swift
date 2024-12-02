//
//  ChannelObject.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

import RealmSwift

final class ChatRoomObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    
    convenience init(
        id: String,
        name: String
    ) {
        self.init()
        self.id = id
        self.name = name
    }
}
