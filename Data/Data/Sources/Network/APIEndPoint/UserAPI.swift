//
//  UserAPI.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation
import Moya

enum UserAPI {
    case kakaoLogin(_ body: KakaoLoginBody)
    case appleLogin(_ body: AppleLoginBody)
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
        case .kakaoLogin(let body):
            return .requestJSONEncodable(body)
        case .appleLogin(let body):
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
