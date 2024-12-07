//
//  WorkspaceItem.swift
//  App
//
//  Created by Jinyoung Yoo on 11/23/24.
//

import Foundation

import WorkSpace
import Chat

enum WorkspaceItem: Hashable {
    case channel(Channel)
    case dm(ChatRoom)
}

