//
//  DIContainer.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/5/24.
//

public enum DIContainer {
    
    static var factoryStorage: [String: () -> AnyObject] = [:]
    static var sharedObjectStorage: [String: WeakWrapper] = [:]
    
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
    
    public static func register<T>(
        _ type: T.Type,
        factory: @escaping () -> AnyObject)
    {
        factoryStorage["\(type)"] = factory
    }
    
    public static func resolve<T>(_ type: T.Type, objectScope: ObjectScope) -> T {
        let key = "\(type)"

        // value가 nil인 WeakWrapper를 sharedObjectStorage에서 지움
        sharedObjectStorage = sharedObjectStorage.filter { $0.value.value != nil }
        
        if let object = sharedObjectStorage[key]?.value as? T {
            return object
        }
        else if let factory = factoryStorage[key], let object = factory() as? T {
            
            if objectScope == .shared {
                sharedObjectStorage[key] = WeakWrapper(value: object as AnyObject)
            }
            
            return object
        } else {
            fatalError("등록되지 않는 객체 호출")
        }
    }
}
