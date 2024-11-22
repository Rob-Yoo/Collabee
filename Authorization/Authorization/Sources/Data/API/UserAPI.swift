//
//  UserAPI.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/19/24.
//

import DataSource

enum UserAPI {
    case kakaoLogin(_ body: KakaoLoginBody)
    case appleLogin(_ body: AppleLoginBody)
    case emailLogin(_ body: EmailLoginBody)
}

extension UserAPI: API {

    public var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        case .emailLogin:
            return "/v1/users/login"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .kakaoLogin, .appleLogin, .emailLogin:
            return .post
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .kakaoLogin(let body):
            return .requestWithEncodableBody(body)
        case .appleLogin(let body):
            return .requestWithEncodableBody(body)
        case .emailLogin(let body):
            return .requestWithEncodableBody(body)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .kakaoLogin, .appleLogin, .emailLogin:
            return [
                Header.contentType.rawValue: Header.json.rawValue
            ]
        }
    }
}
