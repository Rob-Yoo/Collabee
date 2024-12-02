//
//  DataBaseError.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/30/24.
//

public enum DataBaseError: LocalizedError {
    case createError
    case updateError
    case deleteError
    
    public var errorDescription: String? {
        switch self {
        case .createError:
            return "데이터베이스 생성 실패"
        case .updateError:
            return "데이터베이스 수정 실패"
        case .deleteError:
            return "데이터베이스 삭제 실패"
        }
    }
}
