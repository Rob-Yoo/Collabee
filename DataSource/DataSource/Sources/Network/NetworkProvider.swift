//
//  NetworkProvider.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation
import Combine

import Moya
import CombineMoya

protocol NetworkProvider {
    func request<T: TargetType, R: Decodable>(_ target: T, _ responseType: R.Type) -> AnyPublisher<R, CollabeeError>
}

final class DefaultNetworkProvider: NetworkProvider {

    static let shared = DefaultNetworkProvider()
    private let session = Session(interceptor: TokenInterceptor())
    private var cancellable = Set<AnyCancellable>()
    
    private init() {}
    
    func request<T: TargetType, R: Decodable>(_ target: T, _ responseType: R.Type) -> AnyPublisher<R, CollabeeError> {
        let provider = MoyaProvider<T>(session: session, plugins: [MoyaLoggerPlugin()])
        
        return Future<R, CollabeeError> { [weak self] promise in
            
            guard let self else { return }
            
            provider.requestPublisher(target)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        guard let res = error.response else {
                            promise(.failure(.unknownError))
                            return
                        }

                        guard let decodedError = try? res.map(CollabeeError.self) else {
                            promise(.failure(.unknownError))
                            return
                        }
        
                        promise(.failure(decodedError))
                    }
                } receiveValue: { res in
                    guard let result = try? res.map(responseType.self) else {
                        promise(.failure(.unknownError))
                        return
                    }
                    
                    promise(.success(result))
                }.store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
    }
}
