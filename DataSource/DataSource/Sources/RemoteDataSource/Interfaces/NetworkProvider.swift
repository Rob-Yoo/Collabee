//
//  NetworkProvider.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/19/24.
//

import Combine


public protocol NetworkProvider {
    func request<T: API, R: Decodable>(_ target: T, _ responseType: R.Type, _ sessionType: SessionType) -> AnyPublisher<R, NetworkError>
}

public enum SessionType {
    case withToken
    case withoutToken
}
