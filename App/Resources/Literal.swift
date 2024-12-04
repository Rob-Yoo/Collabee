//
//  Literal.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Foundation

enum Literal {
    
    enum InfoDictionary {
        static var KAKAO_NATIVE_KEY: String { "KAKAO_NATIVE_KEY" }
    }
    
    enum Secret {
        
        static var KakaoNativeKey: String? {
            Bundle.main.infoDictionary?[Literal.InfoDictionary.KAKAO_NATIVE_KEY] as? String
        }
    }
}
