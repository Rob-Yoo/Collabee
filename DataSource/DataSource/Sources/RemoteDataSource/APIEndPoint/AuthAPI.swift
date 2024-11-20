//
//  AuthAPI.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/10/24.
//

import Moya

enum AuthAPI {
    case tokenRefresh(_ refreshToken: String)
}

extension AuthAPI: API {
    
    var path: String {
        switch self {
        case .tokenRefresh:
            return "/v1/auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .tokenRefresh:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .tokenRefresh:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .tokenRefresh(let refreshToken):
            return [
                Header.refresh.rawValue: refreshToken
            ]
        }
    }
}
