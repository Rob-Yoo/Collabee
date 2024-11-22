//
//  IdentifierProtocol.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import Foundation

protocol IdentifierProtocol {
    static var identifier: String { get }
}

extension NSObject: IdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

