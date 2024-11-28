//
//  WebSocketError.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/28/24.
//

public enum WebSocketError: LocalizedError {
    case decodeFailure
    
    public var errorDescription: String? {
        switch self {
        case .decodeFailure:
            return "웹소켓 데이터 디코딩 실패"
        }
    }
}
