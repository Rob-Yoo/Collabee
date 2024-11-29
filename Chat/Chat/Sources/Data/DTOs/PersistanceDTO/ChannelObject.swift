//
//  ChannelObject.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

import RealmSwift

final class ChannelObject: Object {
    @Persisted(primaryKey: true) var channelID: String
    @Persisted var workspaceID: String
    @Persisted var name: String
}
