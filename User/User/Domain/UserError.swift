//
//  UserError.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

public enum UserError: LocalizedError {
    case fetchProfileFailure
    case editFailure
    
    public var errorDescription: String? {
        switch self {
        case .fetchProfileFailure:
            return "프로필 정보 조회 실패"
        case .editFailure:
            return "프로필 정보 수정 실패"
        }
    }
}
