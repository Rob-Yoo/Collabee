//
//  TransferOwnershipBody.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

public struct TransferOwnershipBody: Encodable {
    let newOwnerID: String
    
    enum CodingKeys: String, CodingKey {
        case newOwnerID = "owner_ship"
    }
    
    public init(newOwnerID: String) {
        self.newOwnerID = newOwnerID
    }

}
