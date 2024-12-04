//
//  ChatDataRepository.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/30/24.
//

import Combine

public protocol ChatDataRepository {
    func saveChatData(_ chat: Chat) -> AnyPublisher<Chat, ChatError>
    func fetchLastChatDate() -> AnyPublisher<String, Never>
    func fetchChatRoom(_ wsID: String, _ body: EnterRoomBody) -> AnyPublisher<ChatRoom, ChatError>
    func fetchUnreadsCount(_ wsID: String, _ roomID: String, after: String, chatType: ChatType) -> AnyPublisher<Int, ChatError>
    func fetchUnreadChats(_ wsID: String, _ roomID: String, after: String, chatType: ChatType) -> AnyPublisher<[Chat], ChatError>
    func fetchReadChats(_ roomID: String, isPagination: Bool) -> [Chat]
    func fetchChatRoomList(_ wsID: String) -> AnyPublisher<[ChatRoom], ChatError>
}
