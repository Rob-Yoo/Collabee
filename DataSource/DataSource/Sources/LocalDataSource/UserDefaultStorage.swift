//
//  UserDefaultStorage.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

public enum UserDefaultsStorage {
    
    enum Keys: String, CaseIterable {
        case isAuthorized
        case workspaceID
    }
    
    @UserDefault(key: Keys.isAuthorized.rawValue, defaultValue: false)
    public static var isAuthorized: Bool

    @UserDefault(key: Keys.workspaceID.rawValue, defaultValue: nil)
    public static var workspaceID: String?
    
    public static func deleteAll() {
        Keys.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}

