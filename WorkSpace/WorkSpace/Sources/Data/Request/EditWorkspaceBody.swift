//
//  EditWorkspaceBody.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import DataSource

struct EditWorkspaceBody {
    let name: String
    let description: String
    let image: Data?
    
    func makeMultipartFomrData() -> [MultipartFormData] {
        
        var data = [MultipartFormData]()
        
        guard let encodedName = name.data(using: .utf8) else { return [] }
        
        data.append(MultipartFormData(data: encodedName, name: "name"))
        
        if !description.isEmpty, let encodedDescription = description.data(using: .utf8) {
            data.append(MultipartFormData(data: encodedDescription, name: "description"))
        }
        
        if let image {
            data.append(MultipartFormData(data: image, name: "image", fileName: "workspace", mimeType: "image/jpeg"))
        }
        
        return data
    }
}
