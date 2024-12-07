//
//  DefaultSenderRepository.swift
//  Chat
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import DataSource
import Common

public final class DefaultSenderRepository: SenderRepository {
    
    @Injected private var databaseProvider: DataBaseProvider
    
    public init() {}
    
    public func save(_ sender: Sender) {
        let sender = SenderObject(sender)

        databaseProvider.add([sender])
    }
    
    
}
