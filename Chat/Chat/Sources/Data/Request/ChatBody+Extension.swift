//
//  ChatBody+Extension.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

import DataSource

extension ChatBody {
    func makeMultipartFormData() -> [MultipartFormData] {
        var data = [MultipartFormData]()
        
        if !content.isEmpty, let content = self.content.data(using: .utf8) {
            data.append(MultipartFormData(data: content, name: "content"))
        }
        
        images.enumerated().forEach { (idx, imageData) in
            data.append(MultipartFormData(data: imageData, name: "files", fileName: "chat", mimeType: "image/jpeg"))
        }
        
        return data
    }
}
