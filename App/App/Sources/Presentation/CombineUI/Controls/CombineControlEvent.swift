//
//  CombineControlEvent.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine
import Foundation
import UIKit.UIControl

//MARK: - Publisher
extension Combine.Publishers {
 
    struct ControlEvent<Control: UIControl>: Publisher {
        typealias Output = Void
        typealias Failure = Never

        private let control: Control
        private let controlEvents: Control.Event

        init(control: Control,
                    events: Control.Event) {
            self.control = control
            self.controlEvents = events
        }

        func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber,
                                            control: control,
                                            event: controlEvents)

            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - Subscription
extension Combine.Publishers.ControlEvent {
    private final class Subscription<S: Subscriber, C: UIControl>: Combine.Subscription where S.Input == Void {
        private var subscriber: S?
        weak private var control: C?

        init(subscriber: S, control: C, event: C.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(processControlEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
        }

        @objc private func processControlEvent() {
            _ = subscriber?.receive()
        }
    }
}
