//
//  DIContainer.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/6/24.
//

public final class DIContainer {
    public static let shared = DIContainer()
    private let container = Container()
    
    private init() {}
    
    public func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    public func resolve<T>(_ type: T.Type, objectScope: Container.ObjectScope) -> T {
        return container.resolve(type, objectScope: objectScope)
    }
}
