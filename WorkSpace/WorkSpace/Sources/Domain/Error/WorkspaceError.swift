//
//  WorkspaceError.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

public enum WorkspaceError: LocalizedError {
    case creationFailure
    case getListFailure
    case getWorkspaceFailure
    case editFailure
    case deleteFailure
    
    public var errorDescription: String? {
        switch self {
        case .creationFailure:
            return "워크스페이스 생성에 실패하였습니다."
        case .getListFailure:
            return "사용자가 속한 워크스페이스 목록을 불러오는데 실패하였습니다."
        case .getWorkspaceFailure:
            return "워크스페이스 정보를 불러오는데 실패하였습니다."
        case .editFailure:
            return "워크스페이스 편집에 실패하였습니다."
        case .deleteFailure:
            return "워크스페이스 삭제에 실패하였습니다."
        }
    }
}
