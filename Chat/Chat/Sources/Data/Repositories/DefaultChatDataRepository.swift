//
//  DefaultChatDataRepository.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/30/24.
//

import Combine

import DataSource
import Common

import RealmSwift

//MARK: - DIContainer에서 unique 스코프로 관리 되어야 함!
public final class DefaultChatDataRepository: ChatDataRepository {
    
    @Injected private var networkProvider: NetworkProvider
    @Injected private var databaseProvider: DataBaseProvider
    
    private var cursor: ChatObject?
    
    public init() {}
    
    public func saveChatData(_ chat: Chat) -> AnyPublisher<Chat, ChatError> {
        let chatObject = ChatObject(chat)
        
        return databaseProvider.add([chatObject])
            .map { _ in chat }
            .mapError { _ in ChatError.saveChatFailure }
            .eraseToAnyPublisher()
    }
    
    public func fetchLastChatDate() -> AnyPublisher<String, Never> {
        
        guard let lastChatDate = databaseProvider.read(objectType: ChatObject.self)
            .max(of: \.createdAt) else {
            return Just("").eraseToAnyPublisher()
        }
        
        return Just(lastChatDate.toServerDateStr()).eraseToAnyPublisher()
    }
    
    public func fetchUnreadsCount(_ wsID: String, _ roomID: String, after: String, chatType: ChatType) -> AnyPublisher<Int, ChatError> {
        switch chatType {
        case .channel:
            return networkProvider.request(ChannelChatAPI.unreads(wsID, roomID, after), ChannelUnreadsDTO.self, .withToken)
                .map { $0.count }
                .mapError { _ in ChatError.fetchUnreadsFailure }
                .eraseToAnyPublisher()
        case .dm:
            return networkProvider.request(DirectMessageAPI.unreads(wsID, roomID, after), DMUnreadsDTO.self, .withToken)
                .map { $0.count }
                .mapError { _ in ChatError.fetchUnreadsFailure }
                .eraseToAnyPublisher()
        }
    }
    
    public func fetchChatRoomID(_ wsID: String, _ body: EnterRoomBody) -> AnyPublisher<String, ChatError> {
        return networkProvider.request(DirectMessageAPI.enterRoom(wsID, body), ChatRoomDTO.self, .withToken)
            .map { $0.roomID }
            .mapError { _ in ChatError.fetchChatRoomIDFailure }
            .eraseToAnyPublisher()
    }
    
    public func fetchUnreadChats(_ wsID: String, _ roomID: String, after: String, chatType: ChatType) -> AnyPublisher<[Chat], ChatError> {

        switch chatType {
        case .channel:
            return networkProvider.request(ChannelChatAPI.chatList(wsID, roomID, after), [ChannelChatDTO].self, .withToken)
                .map { $0.map { $0.toDomain() } }
                .mapError { _ in ChatError.fetchChatListFailure }
                .withUnretained(self)
                .flatMap { (owner, chatList) -> AnyPublisher<[Chat], ChatError> in
                    
                    return owner.databaseProvider.add(chatList.map { ChatObject($0) })
                        .map { _ in chatList }
                        .mapError { _ in ChatError.saveChatFailure }
                        .eraseToAnyPublisher()
                    
                }
                .eraseToAnyPublisher()
        case .dm:
            return networkProvider.request(DirectMessageAPI.dms(wsID, roomID, after), [DMChatDTO].self, .withToken)
                .map { $0.map { $0.toDomain() } }
                .mapError { _ in ChatError.fetchChatListFailure }
                .withUnretained(self)
                .flatMap { (owner, chatList) -> AnyPublisher<[Chat], ChatError> in
                    
                    return owner.databaseProvider.add(chatList.map { ChatObject($0) })
                        .map { _ in chatList }
                        .mapError { _ in ChatError.saveChatFailure }
                        .eraseToAnyPublisher()
                    
                }.eraseToAnyPublisher()
        }
    }
    
    public func fetchReadChats(_ roomID: String, isPagination: Bool) -> AnyPublisher<[Chat], ChatError> {
        return Future<[Chat], ChatError> { [weak self] promise in
            guard let self else { return }
            
            var chatQuery = databaseProvider.read(objectType: ChatObject.self)
                .where { $0.chatRoom.id == roomID }
                .sorted(by: \.createdAt, ascending: false)
            
            if isPagination, let cursor {
                chatQuery = chatQuery.filter("createdAt < %@", cursor.createdAt)
            }
            
            let limitedChats = chatQuery.prefix(30)
            let chatList = limitedChats.map { $0.toDomain() }
            
            if let newCursor = limitedChats.last {
                self.cursor = newCursor
            }
            
            promise(.success(Array(chatList)))
            
        }.eraseToAnyPublisher()
        
    }
    
    public func fetchChatRoomList(_ wsID: String) -> AnyPublisher<[ChatRoom], ChatError> {
        return networkProvider.request(DirectMessageAPI.dmRooms(wsID), [ChatRoomDTO].self, .withToken)
            .map { $0.map { $0.toDomain() } }
            .mapError { _ in ChatError.fetchChatRoomListFailure }
            .eraseToAnyPublisher()
    }
}
