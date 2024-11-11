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

struct DefaultNetworkProvider: NetworkProvider {

    private let session = Session(interceptor: TokenInterceptor())
    private static var cancellable = Set<AnyCancellable>()
    
    func request<T: TargetType, R: Decodable>(_ target: T, _ responseType: R.Type) -> AnyPublisher<R, CollabeeError> {
        let provider = MoyaProvider<T>(session: session, plugins: [MoyaLoggerPlugin()])
        
        return Future<R, CollabeeError> { promise in
            provider.requestPublisher(target)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("네트워크 작업 종료")
                    case .failure(let error):
                        guard let res = error.response else {
                            print(error.localizedDescription)
                            promise(.failure(.unknownError))
                            return
                        }
        
                        guard let decodedError = try? JSONDecoder().decode(CollabeeError.self, from: res.data) else {
                            print(">>>>>", error.localizedDescription)
                            promise(.failure(.unknownError))
                            return
                        }
        
                        promise(.failure(decodedError))
                    }
                } receiveValue: { res in
                    guard let result = try? JSONDecoder().decode(responseType.self, from: res.data) else {
                        promise(.failure(.unknownError))
                        return
                    }
                    
                    promise(.success(result))
                }.store(in: &Self.cancellable)
        }
        .eraseToAnyPublisher()
    }
}
