//
//  AuthAPI.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/10/24.
//

import Moya

public enum AuthAPI {
    case tokenRefresh(_ refreshToken: String)
}

extension AuthAPI: TargetType {
    
    public var path: String {
        switch self {
        case .tokenRefresh:
            return "/v1/auth/refresh"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .tokenRefresh:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .tokenRefresh:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .tokenRefresh(let refreshToken):
            return [
                Header.refresh.rawValue: refreshToken
            ]
        }
    }
}
