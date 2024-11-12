//
//  Login.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation

struct LoginBody: Encodable {
    let idToken: String
    var nickname: String?
    let deviceToken: String = ""
}
