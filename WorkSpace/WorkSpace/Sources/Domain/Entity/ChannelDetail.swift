//
//  ChannelDetail.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Foundation

public struct ChannelDetail {
    public let channelID: String
    public let name: String
    public let description: String?
    let coverImage: String?
    public let ownerID: String
    let createdAt: String
    public let channelMembers: [Member]
}
