//
//  ChatError.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public enum ChatError: LocalizedError {
    case fetchChatListFailure
    case sendChatFailure
    case fetchUnreadsFailure
    case saveChatFailure
    case receiveChatFailure
    case emptyChatHistory
    case fetchChatRoomListFailure
    case fetchChatRoomIDFailure
    
    public var errorDescription: String? {
        switch self {
        case .fetchChatListFailure:
            return "채팅 목록을 불러오는데 실패"
        case .sendChatFailure:
            return "채팅 전송에 실패"
        case .fetchUnreadsFailure:
            return "안 읽은 메세지 개수를 불러오는데 실패"
        case .saveChatFailure:
            return "채팅 저장에 실패"
        case .receiveChatFailure:
            return "상대방 채팅 수신에 실패"
        case .emptyChatHistory:
            return "채팅 기록이 비어있음"
        case .fetchChatRoomListFailure:
            return "채팅방 목록을 불러오는데 실패"
        case .fetchChatRoomIDFailure:
            return "채팅방 ID를 불러오는데 실패"
        }
    }
}
