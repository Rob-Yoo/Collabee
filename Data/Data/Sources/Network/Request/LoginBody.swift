//
//  Login.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation

struct AppleLoginBody: Encodable {
    let idToken: String
    var nickname: String?
    var deviceToken: String?
}

struct KakaoLoginBody: Encodable {
    let oauthToken: String
    var deviceToken: String?
}
