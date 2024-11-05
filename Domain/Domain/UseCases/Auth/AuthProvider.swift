//
//  AuthProvider.swift
//  Domain
//
//  Created by Jinyoung Yoo on 11/5/24.
//

@objc
public protocol AuthProvider {
    func login()
    @objc optional func handleOpenURL(_ url: URL)
}
