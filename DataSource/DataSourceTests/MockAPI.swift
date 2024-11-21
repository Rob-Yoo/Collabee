//
//  MockAPI.swift
//  DataSourceTests
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Foundation
import Moya
@testable import DataSource

fileprivate struct LoginBody: Encodable {
    let email: String
    let password: String
}

enum MockAPI {
    case login(_ email: String, _ password: String)
}

extension MockAPI: API {
    
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let email, let pwd):
            return .requestWithEncodableBody(LoginBody(email: email, password: pwd))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue
            ]
        }
    }
    
}

extension TargetType {
    var baseURL: URL {
        return URL(string: Literal.Secret.BaseURL)!
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
