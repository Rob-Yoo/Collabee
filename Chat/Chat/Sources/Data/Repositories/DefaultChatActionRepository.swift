//
//  DefaultChatActionRepository.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/30/24.
//

import Combine

import DataSource
import Common

public final class DefaultChatActionRepository: ChatActionRepository {
    
    @Injected private var networkProvider: NetworkProvider
    @Injected private var wsProvider: WebSocketProvider
    
    public init() {}
    
    public func send(_ wsID: String, _ roomID: String, chat: ChatBody, chatType: ChatType) -> AnyPublisher<Chat, ChatError> {
        
        switch chatType {
        case .channel:
            return networkProvider.request(ChannelChatAPI.sendChat(wsID, roomID, chat), ChannelChatDTO.self, .withToken)
                .map { $0.toDomain() }
                .mapError { _ in ChatError.sendChatFailure }
                .eraseToAnyPublisher()
            
        case .dm:
            return networkProvider.request(DirectMessageAPI.sendDM(wsID, roomID, chat), DMChatDTO.self, .withToken)
                .map { $0.toDomain() }
                .mapError { _ in ChatError.sendChatFailure }
                .eraseToAnyPublisher()
        }
    }
    
    public func receive(_ roomID: String, chatType: ChatType) -> AnyPublisher<Chat, ChatError> {
        switch chatType {
        case .channel:
            wsProvider.establishConnection(router: .channel(roomID))
            return wsProvider.receive(.channel(roomID), responseType: ChannelChatDTO.self)
                .map { $0.toDomain() }
                .mapError { _ in ChatError.receiveChatFailure }
                .eraseToAnyPublisher()
        case .dm:
            wsProvider.establishConnection(router: .dm(roomID))
            return wsProvider.receive(.dm(roomID), responseType: DMChatDTO.self)
                .map { $0.toDomain() }
                .mapError { _ in ChatError.receiveChatFailure }
                .eraseToAnyPublisher()
        }
    }
    
    public func disconnect() {
        wsProvider.closeConnection()
    }
}
