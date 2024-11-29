//
//  Sender.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public struct Sender {
    public let id: String
    public let name: String
    public let email: String
    public let profileImage: String?
    
    public init(id: String, name: String, email: String, profileImage: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
    }

}
