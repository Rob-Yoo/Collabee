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
    
    public func saveChatData(_ chat: Chat, _ roomID: String) -> AnyPublisher<Chat, ChatError> {
        let newChatObject = ChatObject(chat)
        
        newChatObject.sender = databaseProvider.readWithPrimaryKey(objectType: SenderObject.self, primaryKey: chat.sender.id) ?? SenderObject(chat.sender)
        
        return databaseProvider.addChats { realm in
            if let chatRoomObject = realm.object(ofType: ChatRoomObject.self, forPrimaryKey: roomID) {
                chatRoomObject.chats.append(newChatObject)
            } else {
                let chatRoomObject = ChatRoomObject(id: roomID)
                chatRoomObject.chats.append(newChatObject)
                realm.add(chatRoomObject)
            }
        }.map { _ in chat }
            .mapError { _ in ChatError.saveChatFailure }
            .eraseToAnyPublisher()
    }
    
    public func fetchLastChatDate(_ roomID: String) -> AnyPublisher<String, Never> {
        
        guard let chatRoom = databaseProvider.readWithPrimaryKey(objectType: ChatRoomObject.self, primaryKey: roomID), let lastChatDate = chatRoom.chats.last?.createdAt else {
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
    
    public func fetchChatRoom(_ wsID: String, _ body: EnterRoomBody) -> AnyPublisher<ChatRoom, ChatError> {
        return networkProvider.request(DirectMessageAPI.enterRoom(wsID, body), ChatRoomDTO.self, .withToken)
            .map { $0.toDomain() }
            .mapError { _ in ChatError.fetchChatRoomIDFailure }
            .eraseToAnyPublisher()
    }
    
    public func fetchUnreadChats(_ wsID: String, _ roomID: String, after: String, chatType: ChatType) -> AnyPublisher<[Chat], ChatError> {

        switch chatType {
        case .channel:
            return networkProvider.request(ChannelChatAPI.chatList(wsID, roomID, after), [ChannelChatDTO].self, .withToken)
                .map { $0.map { $0.toDomain() } }
                .mapError { _ in ChatError.fetchChatListFailure }
                .eraseToAnyPublisher()
        case .dm:
            return networkProvider.request(DirectMessageAPI.dms(wsID, roomID, after), [DMChatDTO].self, .withToken)
                .map { $0.map { $0.toDomain() } }
                .mapError { _ in ChatError.fetchChatListFailure }
                .withUnretained(self)
                .flatMap { (owner, chatList) -> AnyPublisher<[Chat], ChatError> in
                    
                    return owner.databaseProvider.addChats { realm in
                        if let chatRoomObject = realm.object(ofType: ChatRoomObject.self, forPrimaryKey: roomID) {
                            chatList.forEach {
                                
                                let chatObject = ChatObject($0)
                                
                                chatObject.sender = realm.object(ofType: SenderObject.self, forPrimaryKey: $0.sender.id) ?? SenderObject($0.sender)
                                
                                chatRoomObject.chats.append(chatObject)
                            }
                        } else {
                            let chatRoomObject = ChatRoomObject(id: roomID)
                            
                            realm.add(chatRoomObject, update: .modified)
                            chatList.forEach {
                                
                                let chatObject = ChatObject($0)
                                
                                chatObject.sender = realm.object(ofType: SenderObject.self, forPrimaryKey: $0.sender.id) ?? SenderObject($0.sender)
                                
                                chatRoomObject.chats.append(chatObject)
                            }
                        }
                    }
                        .map { _ in chatList }
                        .mapError { _ in ChatError.saveChatFailure }
                        .eraseToAnyPublisher()
                    
                }.eraseToAnyPublisher()
        }
    }
    
    public func fetchReadChats(_ roomID: String, isPagination: Bool) -> [Chat] {
        var chatQuery = databaseProvider.readWithPrimaryKey(objectType: ChatRoomObject.self, primaryKey: roomID)?.chats
            .sorted(by: \.createdAt, ascending: true)
        
        if isPagination, let cursor {
            chatQuery = chatQuery?.filter("createdAt < %@", cursor.createdAt)
        }
        
        let limitedChats = chatQuery?.prefix(30)
        let chatList = limitedChats?.map { $0.toDomain() }
        
        if let newCursor = limitedChats?.last {
            self.cursor = newCursor
        }
        
        
        return chatList?.map { $0 } ?? []
        
    }
    
    public func fetchChatRoomList(_ wsID: String) -> AnyPublisher<[ChatRoom], ChatError> {
        return networkProvider.request(DirectMessageAPI.dmRooms(wsID), [ChatRoomDTO].self, .withToken)
            .map { $0.map { $0.toDomain() } }
            .mapError { _ in ChatError.fetchChatRoomListFailure }
            .eraseToAnyPublisher()
    }
}
