//
//  ChannelDetail.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Foundation

public struct ChannelDetail {
    let channelID: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerID: String
    let createdAt: Date
    let channelMembers: [Member]
}
