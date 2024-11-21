//
//  WorkspaceMemberError.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

public enum WorkspaceMemberError: LocalizedError {
    
    case inviteFailure
    case loadFailure
    
    public var errorDescription: String? {
        switch self {
        case .inviteFailure:
            return "멤버 초대에 실패하였습니다."
        case .loadFailure:
            return "워크스페이스 멤버 정보를 불러오는데 실패하였습니다."
        }
    }
}
