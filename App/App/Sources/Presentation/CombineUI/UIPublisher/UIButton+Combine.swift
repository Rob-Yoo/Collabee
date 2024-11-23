//
//  UIButton+Combine.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine
import UIKit

extension UIButton {
    var tap: AnyPublisher<Void, Never> {
        return controlEventPublisher(for: .touchUpInside)
    }
}
