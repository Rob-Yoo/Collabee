//
//  Request.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

public struct CreateWorkspaceBody {
    let name: String
    let description: String
    let image: Data?
    
    public init(name: String, description: String, image: Data?) {
        self.name = name
        self.description = description
        self.image = image
    }
}
