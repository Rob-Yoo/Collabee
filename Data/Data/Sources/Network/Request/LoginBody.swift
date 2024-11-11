//
//  Login.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation

struct KakaoLoginBody: Encodable {
    let oauthToken: String
    let deviceToken: String
    
    init(oauthToken: String, deviceToken: String = "") {
        self.oauthToken = oauthToken
        self.deviceToken = deviceToken
    }
}

struct AppleLoginBody: Encodable {
    let idToken: String
    let nickname: String
    let deviceToken: String
    
    init(idToken: String, nickname: String, deviceToken: String = "") {
        self.idToken = idToken
        self.nickname = nickname
        self.deviceToken = deviceToken
    }
}
