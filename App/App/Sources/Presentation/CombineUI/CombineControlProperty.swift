//
//  CombineControlProperty.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine
import Foundation
import UIKit.UIControl

// MARK: - Publisher
extension Combine.Publishers {

    struct ControlProperty<Control: UIControl, Value>: Publisher {
        typealias Output = Value
        typealias Failure = Never

        private let control: Control
        private let controlEvents: Control.Event
        private let keyPath: KeyPath<Control, Value>

        init(control: Control,
                    events: Control.Event,
                    keyPath: KeyPath<Control, Value>) {
            self.control = control
            self.controlEvents = events
            self.keyPath = keyPath
        }

        func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber,
                                            control: control,
                                            event: controlEvents,
                                            keyPath: keyPath)

            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - Subscription
extension Combine.Publishers.ControlProperty {
    private final class Subscription<S: Subscriber, C: UIControl, V>: Combine.Subscription where S.Input == V {
        
        private var subscriber: S?
        weak private var control: C?
        let keyPath: KeyPath<C, V>
        private var didEmitInitial = false
        private let event: C.Event

        init(subscriber: S, control: C, event: C.Event, keyPath: KeyPath<C, V>) {
            self.subscriber = subscriber
            self.control = control
            self.keyPath = keyPath
            self.event = event
            control.addTarget(self, action: #selector(processControlEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) {
            
            if !didEmitInitial,
                demand > .none,
                let control,
                let subscriber {
                
                _ = subscriber.receive(control[keyPath: keyPath])
                didEmitInitial = true
                
            }

        }

        func cancel() {
            control?.removeTarget(self, action: #selector(processControlEvent), for: event)
            subscriber = nil
        }

        @objc private func processControlEvent() {
            
            guard let control else { return }
            
            _ = subscriber?.receive(control[keyPath: keyPath])
            
        }
    }
}

extension UIControl.Event {
    static var defaultValueEvents: UIControl.Event {
        return [.allEditingEvents, .valueChanged]
    }
}
