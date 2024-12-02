//
//  UserDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

import RealmSwift

final class SenderObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var senderName: String
    @Persisted var email: String
    @Persisted var profileImage: String?
}

extension SenderObject {
    convenience init(_ entity: Sender) {
        self.init()
        self.id = entity.id
        self.senderName = entity.name
        self.email = entity.email
        self.profileImage = entity.profileImage
    }
    
    func toDomain() -> Sender {
        return Sender(id: self.id,
                      name: self.senderName,
                      email: self.email,
                      profileImage: self.profileImage)
    }
}
