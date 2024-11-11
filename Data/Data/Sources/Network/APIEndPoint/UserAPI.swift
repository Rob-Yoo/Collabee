//
//  UserAPI.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation
import Moya

enum UserAPI {
    case kakaoLogin(_ authToken: String)
    case appleLogin(_ idToken: String, _ nickname: String)
}

extension UserAPI: TargetType {
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .appleLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let authToken):
            let body = KakaoLoginBody(oauthToken: authToken)
            return .requestJSONEncodable(body)
        case .appleLogin(let idToken, let nickname):
            let body = AppleLoginBody(idToken: idToken, nickname: nickname)
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .kakaoLogin, .appleLogin:
            return [
                Header.contentType.rawValue: Header.json.rawValue
            ]
        }
    }
}
