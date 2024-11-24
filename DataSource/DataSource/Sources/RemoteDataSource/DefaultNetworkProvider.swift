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

public final class DefaultNetworkProvider: NetworkProvider {
    
    private let sessions: [SessionType: Session] = [.withoutToken: Session(interceptor: ServerKeyAdapter()), .withToken: Session(interceptor: TokenInterceptor())]
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    public func request<T: API, R: Decodable>(_ target: T, _ responseType: R.Type, _ sessionType: SessionType) -> AnyPublisher<R, NetworkError> {
        let adaptedTarget = APIAdapter(api: target)
        let provider = MoyaProvider<APIAdapter>(session: sessions[sessionType]!, plugins: [MoyaLoggerPlugin()])
        
        return Future<R, NetworkError> { [weak self] promise in
            
            guard let self else { return }
            
            provider.requestPublisher(adaptedTarget)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        guard let res = error.response else {
                            promise(.failure(.unknownError))
                            return
                        }

                        guard let decodedError = try? res.map(NetworkError.self) else {
                            promise(.failure(.unknownError))
                            return
                        }
        
                        promise(.failure(decodedError))
                    }
                } receiveValue: { res in
                    guard let result = try? res.map(responseType.self) else {
                        promise(.failure(.decodingFailure))
                        return
                    }
                    
                    promise(.success(result))
                }.store(in: &self.cancellable)
        }
        .eraseToAnyPublisher()
    }
}
