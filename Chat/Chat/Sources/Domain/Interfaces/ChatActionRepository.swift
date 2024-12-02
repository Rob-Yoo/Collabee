//
//  ChatActionRepository.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/30/24.
//

import Combine

public protocol ChatActionRepository {
    func send(_ wsID: String, _ roomID: String, chat: ChatBody, chatType: ChatType) -> AnyPublisher<Chat, ChatError>
    func receive(_ roomID: String, chatType: ChatType) -> AnyPublisher<Chat, ChatError>
    func disconnect()
}
