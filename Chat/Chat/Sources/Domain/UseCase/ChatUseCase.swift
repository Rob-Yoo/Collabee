//
//  ChatUseCase.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/30/24.
//

import Combine

import Common

public protocol ChatUseCase {
    func sendChat(_ wsID: String, _ roomID: String, chat: ChatBody, chatType: ChatType) -> AnyPublisher<Chat, ChatError>
    func receiveChat(_ roomID: String, chatType: ChatType) -> AnyPublisher<Chat, ChatError>
    func disconnect()
    func getChatRoom(_ wsID: String, _ body: EnterRoomBody) -> AnyPublisher<ChatRoom, ChatError>
    func getNumberOfUnreads(_ wsID: String, _ roomID: String, chatType: ChatType) -> AnyPublisher<Int, ChatError>
    func getChatRoomList(_ wsID: String) -> AnyPublisher<[ChatRoom], ChatError>
    func loadUnreadChats(_ wsID: String, _ roomID: String, chatType: ChatType) -> AnyPublisher<[Chat], ChatError>
    func loadReadChats(_ roomID: String, isPagination: Bool) -> [Chat]
}

//MARK: ChatDataRepository가 Unique 스코프이므로 UseCase도 Unique여야 함
public final class DefaultChatUseCase: ChatUseCase {
    
    @Injected private var chatActionRepository: ChatActionRepository
    
    @Injected(objectScope: .unique)
    private var chatDataRepository: ChatDataRepository
    
    public init() {}
    
    public func sendChat(_ wsID: String, _ roomID: String, chat: ChatBody, chatType: ChatType) -> AnyPublisher<Chat, ChatError> {
        // 1. 서버로 채팅 전송(HTTP)
        // 2. Local DB에 채팅 저장
        return chatActionRepository.send(wsID, roomID, chat: chat, chatType: chatType)
            .withUnretained(self)
            .flatMap { (owner, chat) -> AnyPublisher<Chat, ChatError> in
                return owner.chatDataRepository.saveChatData(chat)
            }
            .eraseToAnyPublisher()
    }
    
    public func receiveChat(_ roomID: String, chatType: ChatType) -> AnyPublisher<Chat, ChatError> {
        // 1. 서버로부터 채팅 수신(WebSocket)
        // 2. LocalDB에 채팅 저장
        return chatActionRepository.receive(roomID, chatType: chatType)
            .withUnretained(self)
            .flatMap { (owner, chat) -> AnyPublisher<Chat, ChatError> in
                return owner.chatDataRepository.saveChatData(chat)
            }.eraseToAnyPublisher()
    }
    
    public func disconnect() {
        chatActionRepository.disconnect()
    }
    
    public func getChatRoom(_ wsID: String, _ body: EnterRoomBody) -> AnyPublisher<ChatRoom, ChatError> {
        return chatDataRepository.fetchChatRoom(wsID, body)
    }
    
    public func getNumberOfUnreads(_ wsID: String, _ roomID: String, chatType: ChatType) -> AnyPublisher<Int, ChatError> {
        // 1. Local DB로부터 가장 마지막 메세지의 날짜 받아오기
        // 1. 서버로부터 해당 날짜 이후로 안 읽은 메세지 개수 받아오기(HTTP)
        return chatDataRepository.fetchLastChatDate()
            .withUnretained(self)
            .flatMap { (owner, after) -> AnyPublisher<Int, ChatError> in
                return owner.chatDataRepository.fetchUnreadsCount(wsID, roomID, after: after, chatType: chatType)
            }.eraseToAnyPublisher()
    }
    
    public func getChatRoomList(_ wsID: String) -> AnyPublisher<[ChatRoom], ChatError> {
        return chatDataRepository.fetchChatRoomList(wsID)
    }
    
    public func loadUnreadChats(_ wsID: String, _ roomID: String, chatType: ChatType) -> AnyPublisher<[Chat], ChatError> {
        // 1. Local DB로부터 가장 마지막 메세지의 날짜 받아오기
        // 2. 서버로 해당 날짜 이후의 채팅 목록 가져오기(HTTP)
        return chatDataRepository.fetchLastChatDate()
            .withUnretained(self)
            .flatMap { (owner, after) -> AnyPublisher<[Chat], ChatError> in
                return owner.chatDataRepository.fetchUnreadChats(wsID, roomID, after: after, chatType: chatType)
            }
            .eraseToAnyPublisher()
    }
    
    public func loadReadChats(_ roomID: String, isPagination: Bool) -> [Chat] {
        // 1. Local DB로부터 이전 날짜에 대한 오프셋 페이지네이션 요청
        return chatDataRepository.fetchReadChats(roomID, isPagination: isPagination)
    }

}
