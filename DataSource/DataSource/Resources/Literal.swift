//
//  Literal.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Foundation

enum Literal {
    
    enum InfoDictionary {
        static var SERVER_KEY: String { "SERVER_KEY" }
        static var BASE_URL: String { "BASE_URL" }
        static var SOCKET_URL: String { "SOCKET_URL" }
    }
    
    enum Secret {
        
        static var BaseURL: String {
            guard let bundleData = Bundle.main.infoDictionary?[Literal.InfoDictionary.BASE_URL], let urlString = bundleData as? String else {
                print("변형 실패")
                return ""
            }

            return urlString
        }
        
        static var ServerKey: String? {
            guard let serverKey = Bundle.main.infoDictionary?[Literal.InfoDictionary.SERVER_KEY] as? String else {
                print("서버키 미등록")
                return nil
            }
            
            return serverKey
        }

        static var SocketURL: String {
            guard let socketURL = Bundle.main.infoDictionary?[Literal.InfoDictionary.SOCKET_URL] as? String else {
                print("소켓 URL 미등록")
                return ""
            }
            
            return socketURL
        }
    }
}
