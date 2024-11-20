//
//  AuthorizationError.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/16/24.
//

public enum AuthorizationError: LocalizedError {
    case loginFailure
    
    public var errorDescription: String? {
        return "로그인 실패"
    }
}
