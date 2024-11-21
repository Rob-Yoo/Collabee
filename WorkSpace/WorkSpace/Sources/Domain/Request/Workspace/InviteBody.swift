//
//  InviteBody.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

public struct InviteBody: Encodable {
    let email: String
    
    public init(email: String) {
        self.email = email
    }
    
}
