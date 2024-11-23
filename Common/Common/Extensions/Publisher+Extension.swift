//
//  Publisher+Extension.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import Combine

public extension Publisher {
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}
