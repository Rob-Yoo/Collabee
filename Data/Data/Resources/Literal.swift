//
//  Literal.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation

enum Literal {
    static var bundleIdentifier: String { "com.jinyoo.Data" }
    
    enum InfoDictionary {
        static var SERVER_KEY: String { "SERVER_KEY" }
        static var BASE_URL: String { "BASE_URL" }
    }
    
    enum Secret {
        
        static var BaseURL: String {
            guard let bundleData = Bundle(identifier: Literal.bundleIdentifier)?.infoDictionary?[Literal.InfoDictionary.BASE_URL], let urlString = bundleData as? String else {
                print("변형 실패")
                return ""
            }
            
            print(">>>>>", urlString)
            return urlString
        }
        
        static var ServerKey: String? {
            guard let serverKey = Bundle(identifier: Literal.bundleIdentifier)?.infoDictionary?[Literal.InfoDictionary.SERVER_KEY] as? String else {
                print("서버키 미등록")
                return nil
            }
            
            return serverKey
        }
    }
}
