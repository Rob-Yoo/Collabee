//
//  UserDTO.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

import RealmSwift

final class SenderObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var senderName: String
    @Persisted var email: String
    @Persisted var profileImage: String?
}
