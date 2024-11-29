//
//  ChannelChatObject.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

import RealmSwift

class ChannelChatObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var channel: ChannelObject?
    @Persisted var sender: SenderObject?
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
}
