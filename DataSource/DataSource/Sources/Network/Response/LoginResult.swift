//
//  LoginResultDTO.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation

struct LoginResult: Decodable {
    let token: Token
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}
