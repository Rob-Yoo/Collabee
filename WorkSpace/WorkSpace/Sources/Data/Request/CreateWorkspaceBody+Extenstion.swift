//
//  CreateWorkspaceBody.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import DataSource

extension CreateWorkspaceBody {
    
    func makeMultipartFomrData() -> [MultipartFormData] {
        
        var data = [MultipartFormData]()
        
        guard let encodedName = name.data(using: .utf8) else { return [] }
        
        data.append(MultipartFormData(data: encodedName, name: "name"))
        data.append(MultipartFormData(data: image, name: "image", fileName: "workspace", mimeType: "image/jpeg"))
        
        if !description.isEmpty, let encodedDescription = description.data(using: .utf8) {
            data.append(MultipartFormData(data: encodedDescription, name: "description"))
        }
        
        return data
    }

}
