//
//  UIViewController+Combine.swift
//  App
//
//  Created by Jinyoung Yoo on 11/23/24.
//

import UIKit
import Combine

extension UIViewController {
    
    private static var swizzlingExecuted = false

    static func swizzleLifecycleMethods() {
        guard !swizzlingExecuted else { return }
        
        swizzlingExecuted = true
        
        let originalSelectors = [
            #selector(UIViewController.viewDidLoad),
            #selector(UIViewController.viewWillAppear(_:)),
            #selector(UIViewController.viewDidAppear(_:)),
            #selector(UIViewController.viewIsAppearing(_:)),
            #selector(UIViewController.viewWillDisappear(_:)),
            #selector(UIViewController.viewDidDisappear(_:))
        ]
        
        let swizzledSelectors = [
            #selector(UIViewController.swizzled_viewDidLoad),
            #selector(UIViewController.swizzled_viewWillAppear(_:)),
            #selector(UIViewController.swizzled_viewDidAppear(_:)),
            #selector(UIViewController.swizzled_viewIsAppearing(_:)),
            #selector(UIViewController.swizzled_viewWillDisappear(_:)),
            #selector(UIViewController.swizzled_viewDidDisappear(_:))
        ]
        
        for (originalSelector, swizzledSelector) in zip(originalSelectors, swizzledSelectors) {
            guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
                  let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
                continue
            }
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    @objc private func swizzled_viewDidLoad() {
        self.swizzled_viewDidLoad()
        viewDidLoadSubject.send(())
    }
    
    @objc private func swizzled_viewWillAppear(_ animated: Bool) {
        self.swizzled_viewWillAppear(animated)
        viewWillAppearSubject.send(())
    }
    
    @objc private func swizzled_viewDidAppear(_ animated: Bool) {
        self.swizzled_viewDidAppear(animated)
        viewDidAppearSubject.send(())
    }
    
    @objc private func swizzled_viewIsAppearing(_ animated: Bool) {
        self.swizzled_viewIsAppearing(animated)
        viewIsAppearingSubject.send(())
    }
    
    @objc private func swizzled_viewWillDisappear(_ animated: Bool) {
        self.swizzled_viewWillDisappear(animated)
        viewWillDisappearSubject.send(())
    }
    
    @objc private func swizzled_viewDidDisappear(_ animated: Bool) {
        self.swizzled_viewDidDisappear(animated)
        viewDidDisappearSubject.send(())
    }
    
    private var viewDidLoadSubject: CurrentValueSubject<Void, Never> {
        associatedObject(forKey: &AssociatedKeys.viewDidLoad) {
            CurrentValueSubject<Void, Never>(())
        }
    }
    
    private var viewWillAppearSubject: PassthroughSubject<Void, Never> {
        associatedObject(forKey: &AssociatedKeys.viewWillAppear) {
            PassthroughSubject<Void, Never>()
        }
    }
    
    private var viewDidAppearSubject: PassthroughSubject<Void, Never> {
        associatedObject(forKey: &AssociatedKeys.viewDidAppear) {
            PassthroughSubject<Void, Never>()
        }
    }
    
    private var viewIsAppearingSubject: PassthroughSubject<Void, Never> {
        associatedObject(forKey: &AssociatedKeys.viewIsAppearing) {
            PassthroughSubject<Void, Never>()
        }
    }
    
    private var viewWillDisappearSubject: PassthroughSubject<Void, Never> {
        associatedObject(forKey: &AssociatedKeys.viewWillDisappear) {
            PassthroughSubject<Void, Never>()
        }
    }
    
    private var viewDidDisappearSubject: PassthroughSubject<Void, Never> {
        associatedObject(forKey: &AssociatedKeys.viewDidDisappear) {
            PassthroughSubject<Void, Never>()
        }
    }
    
    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        viewDidLoadSubject.eraseToAnyPublisher()
    }
    
    var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        viewWillAppearSubject.eraseToAnyPublisher()
    }
    
    var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        viewDidAppearSubject.eraseToAnyPublisher()
    }
    
    var viewIsAppearingPublisher: AnyPublisher<Void, Never> {
        viewIsAppearingSubject.eraseToAnyPublisher()
    }
    
    var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        viewWillDisappearSubject.eraseToAnyPublisher()
    }
    
    var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        viewDidDisappearSubject.eraseToAnyPublisher()
    }
}

extension UIViewController {
    private struct AssociatedKeys {
        static var viewDidLoad = 0
        static var viewWillAppear = 1
        static var viewDidAppear = 2
        static var viewIsAppearing = 3
        static var viewWillDisappear = 4
        static var viewDidDisappear = 5
    }
    
    func associatedObject<T>(forKey key: UnsafeRawPointer, initial: () -> T) -> T {
        if let value = objc_getAssociatedObject(self, key) as? T {
            return value
        }
        let initialValue = initial()
        objc_setAssociatedObject(self, key, initialValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return initialValue
    }
}

