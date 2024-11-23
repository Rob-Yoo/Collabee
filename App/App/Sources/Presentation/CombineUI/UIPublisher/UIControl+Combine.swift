//
//  UIControl+Combine.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine
import UIKit

public extension UIControl {
    func controlEventPublisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        Publishers.ControlEvent(control: self, events: events)
                  .eraseToAnyPublisher()
    }
}
