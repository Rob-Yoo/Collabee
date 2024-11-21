//
//  ChannelError.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

public enum ChannelError: LocalizedError {
    case creationFailure
    case getListFailure
    
    public var errorDescription: String? {
        switch self {
        case .creationFailure:
            return "채널 생성에 실패하였습니다."
        case .getListFailure:
            return "채널 목록을 불러오는데 실패하였습니다."
        }
    }
}
