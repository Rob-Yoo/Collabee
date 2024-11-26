//
//  Member.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

public struct Member: Hashable {
    public let id: String
    public let email: String
    public let nickname: String
    public let profileImage: String?
    
    public init(id: String, email: String, nickname: String, profileImage: String?) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
