//
//  User.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

public struct User {
    public let userID: String
    public let nickname: String
    public let profileImage: String
    
    public init(userID: String, nickname: String, profileImage: String) {
        self.userID = userID
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

