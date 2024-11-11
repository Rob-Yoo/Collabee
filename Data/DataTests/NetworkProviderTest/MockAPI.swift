//
//  MockAPI.swift
//  DataTests
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Moya
@testable import Data

fileprivate struct LoginBody: Encodable {
    let email: String
    let password: String
}

enum MockAPI {
    case login(_ email: String, _ password: String)
}

extension TargetType {
    var baseURL: URL {
        return URL(string: Literal.Secret.BaseURL)!
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension MockAPI: TargetType {
    
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let email, let pwd):
            return .requestJSONEncodable(LoginBody(email: email, password: pwd))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [
                Header.serverKey.rawValue: Literal.Secret.ServerKey ?? "",
                Header.contentType.rawValue: Header.json.rawValue
            ]
        }
    }
    
}
