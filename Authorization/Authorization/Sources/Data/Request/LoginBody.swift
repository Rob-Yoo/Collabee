//
//  LoginBody.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/19/24.
//

import Foundation

struct AppleLoginBody: Encodable {
    let idToken: String
    var nickname: String?
    var deviceToken: String?
    
    public init(idToken: String, nickname: String? = nil, deviceToken: String? = nil) {
        self.idToken = idToken
        self.nickname = nickname
        self.deviceToken = deviceToken
    }
}

struct KakaoLoginBody: Encodable {
    let oauthToken: String
    var deviceToken: String?
    
    public init(oauthToken: String, deviceToken: String? = nil) {
        self.oauthToken = oauthToken
        self.deviceToken = deviceToken
    }

}

struct EmailLoginBody: Encodable {
    let email: String
    let password: String
}
