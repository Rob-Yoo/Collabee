//
//  DIContainer.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/5/24.
//

public final class Container {
    
    var factoryStorage: [String: (Container) -> AnyObject] = [:]
    var sharedObjectStorage: [String: WeakWrapper] = [:]
    
    final class WeakWrapper {
        weak var value: AnyObject?
        
        init(value: AnyObject) {
            self.value = value
        }
    }
    
    public enum ObjectScope {
        case unique
        case shared
    }
    
    public init() {}
    
    public func register<T>(
        _ type: T.Type,
        factory: @escaping (Container) -> AnyObject)
    {
        factoryStorage["\(type)"] = factory
    }
    
    public func resolve<T>(_ type: T.Type, objectScope: ObjectScope) -> T {
        let key = "\(type)"

        // value가 nil인 WeakWrapper를 sharedObjectStorage에서 지움
        sharedObjectStorage = sharedObjectStorage.filter { $0.value.value != nil }
        
        if let object = sharedObjectStorage[key]?.value as? T {
            return object
        }
        else if let factory = factoryStorage[key], let object = factory(self) as? T {
            
            if objectScope == .shared {
                sharedObjectStorage[key] = WeakWrapper(value: object as AnyObject)
            }
            
            return object
        } else {
            fatalError("등록되지 않는 객체 호출")
        }
    }
}
