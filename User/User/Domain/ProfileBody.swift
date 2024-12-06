//
//  ProfileBody.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import Foundation

public struct ProfileBody: Encodable {
    public let nickname: String
    public let phone: String
    
    public init(nickname: String, phone: String) {
        self.nickname = nickname
        self.phone = phone
    }
}
