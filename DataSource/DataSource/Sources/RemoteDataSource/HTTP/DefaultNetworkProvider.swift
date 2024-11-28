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
    
    public func requestImage(_ target: ImageAPI) -> AnyPublisher<Data, NetworkError> {
        
        let adaptedTarget = APIAdapter(api: target)
        let requestClosure = { (endPoint: Endpoint, done: MoyaProvider<APIAdapter>.RequestResultClosure) in
            var request: URLRequest? = try? endPoint.urlRequest()
            request?.cachePolicy = .reloadIgnoringLocalCacheData
            done(.success(request!))
        }
        let provider = MoyaProvider<APIAdapter>(requestClosure: requestClosure, session: sessions[.withToken]!, plugins: [MoyaLoggerPlugin()])
        
        return Future<Data, NetworkError> { [weak self] promise in
            
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
                            
                            if res.statusCode == 304 {
                                promise(.failure(.notModified))
                            }
                            
                            return
                        }
                        
                        promise(.failure(decodedError))
                    }
                } receiveValue: { res in
                    guard let etag = res.response?.allHeaderFields["Etag"] as? String else {
                        print("Header 필드에 ETag 값이 없음")
                        return promise(.failure(.unknownError))
                    }

                    // Etag 저장
                    let imagePath = target.path.replacingOccurrences(of: "/v1", with: "")
                    UserDefaults.standard.setValue(etag, forKey: imagePath)

                    promise(.success(res.data))
                }.store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
        
    }
}
