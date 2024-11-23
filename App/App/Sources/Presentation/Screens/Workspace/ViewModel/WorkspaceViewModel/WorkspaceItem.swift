//
//  WorkspaceItem.swift
//  App
//
//  Created by Jinyoung Yoo on 11/23/24.
//

import Foundation

import WorkSpace

enum WorkspaceItem: Hashable {
    case channel(Channel)
    case dm(String)
}

