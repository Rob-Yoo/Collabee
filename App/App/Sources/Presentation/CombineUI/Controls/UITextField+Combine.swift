//
//  UITextField+Combine.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine
import UIKit

extension UITextField {
    
    var textPublisher: AnyPublisher<String?, Never> {
        return Publishers.ControlProperty(control: self, events: .defaultValueEvents, keyPath: \.text).eraseToAnyPublisher()
    }
    
}

extension Publisher where Output == String?, Failure == Never {
    var orEmpty: AnyPublisher<String, Never> {
        return self.map { $0 ?? "" }.eraseToAnyPublisher()
    }
}
