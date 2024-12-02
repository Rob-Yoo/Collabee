//
//  ChatBody.swift
//  Chat
//
//  Created by Jinyoung Yoo on 11/29/24.
//

public struct ChatBody {
    let content: String
    let images: [Data]
    
    public init(content: String, images: [Data]) {
        self.content = content
        self.images = images
    }
}
