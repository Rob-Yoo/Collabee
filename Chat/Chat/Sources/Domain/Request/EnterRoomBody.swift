//
//  EnterRoomBody.swift
//  Chat
//
//  Created by Jinyoung Yoo on 12/2/24.
//

public struct EnterRoomBody: Encodable {
    let opponentID: String
    
    enum CodingKeys: String, CodingKey {
        case opponentID = "opponent_id"
    }
    
    public init(opponentID: String) {
        self.opponentID = opponentID
    }
}
