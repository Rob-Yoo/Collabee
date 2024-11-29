//
//  Unreads.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import Foundation

public struct Unreads {
    public let id: String
    public let count: Int
    
    public init(id: String, count: Int) {
        self.id = id
        self.count = count
    }
}
