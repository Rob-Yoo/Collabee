//
//  Channel.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

public struct Channel: Hashable {
    public let id: String
    public let name: String
    public let description: String?
    let createdAt: String
    public let ownerID: String
    
    public init(id: String, name: String, description: String?, createdAt: String, ownerID: String) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.ownerID = ownerID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
