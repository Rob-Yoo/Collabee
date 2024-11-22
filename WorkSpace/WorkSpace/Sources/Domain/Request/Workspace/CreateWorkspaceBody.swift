//
//  Request.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

public struct CreateWorkspaceBody {
    let name: String
    let description: String
    let image: Data
    
    public init(name: String, description: String, image: Data) {
        self.name = name
        self.description = description
        self.image = image
    }
}

public struct CreateWorkSpaceBodyBuilder {
    private var name: String = ""
    private var description: String = ""
    private var image: Data = Data()
    
    public init() {}
    
    mutating public func name(_ workspaceName: String) {
        self.name = workspaceName
    }
    
    mutating public func description(_ des: String) {
        self.description = des
    }
    
    mutating public func image(_ image: Data) {
        self.image = image
    }
    
    public func build() -> CreateWorkspaceBody {
        return CreateWorkspaceBody(name: name, description: description, image: image)
    }
}
