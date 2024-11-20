//
//  TransferOwnershipBody.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct TransferOwnershipBody: Encodable {
    let newOwnerID: String
    
    enum CodingKeys: String, CodingKey {
        case newOwnerID = "owner_ship"
    }
}
