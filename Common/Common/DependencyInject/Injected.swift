//
//  Injected.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/5/24.
//

@propertyWrapper 
public struct Injected<Dependency> {
    public var wrappedValue: Dependency
    
    public init(objectScope: Container.ObjectScope = .shared) {
        self.wrappedValue = DIContainer.shared.resolve(Dependency.self, objectScope: objectScope)
    }
}
