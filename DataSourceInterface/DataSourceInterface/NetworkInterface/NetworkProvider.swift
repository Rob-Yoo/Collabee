//
//  NetworkProvider.swift
//  DataSourceInterface
//
//  Created by Jinyoung Yoo on 11/18/24.
//

import Combine

public protocol NetworkProvider {
    func requestWithAuthorization<T: API, R: Decodable, E: Error>(_ target: T, _ responseType: R.Type, _ errorType: E) -> AnyPublisher<R, E>
    
    func requestWithoutAuthorization<T: API, E: Error>(_ target: T, errorType: E) -> AnyPublisher<Void, E>
}
