//
//  TargetType+Extension.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/10/24.
//

import Moya

extension TargetType {
    var baseURL: URL {
        return URL(string: Literal.Secret.BaseURL)!
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
