//
//  ChannelRepository.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Combine

public protocol ChannelRepository {
    func create(_ workspaceID: String, _ body: ChannelBody) -> AnyPublisher<Channel, ChannelError>
    func fetchAll(_ workspaceID: String) -> AnyPublisher<[Channel], ChannelError>
    func fetchMyChannels(_ workspaceID: String) -> AnyPublisher<[Channel], ChannelError>
}
