//
//  KeyChain.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/12/24.
//

import Foundation
import Security

public final class KeyChain {
    
    public static let shared = KeyChain()
    private let service = "Collabee"
    
    private init() {}
    
    public func save(_ data: Data, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            print("Keychain 저장 실패: \(status)")
            return
        }
        print("Keychain 저장 성공: \(account)")
    }
    
    public func read(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("키체인 접근 실패: \(status)")
            return nil
        }
        
        return result as? Data
    }
    
    public func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            print("키체인 삭제 실패: \(status)")
            return
        }
        print("Keychain 삭제 성공: \(account)")
    }
}
