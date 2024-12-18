//
//  AccessTokenRetrier.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Alamofire

final class TokenInterceptor: RequestInterceptor, @unchecked Sendable {
    
    private var requestsToRetry: [(RetryResult) -> Void] = []
    private var isRefreshing = false
    private let retrySemaphore = DispatchSemaphore(value: 1)
    private let retryLimit = 3
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        guard let serverKey = Literal.Secret.ServerKey else { return }

        if let accessToken = TokenStorage.read(.access) {
            urlRequest.setValue(accessToken, forHTTPHeaderField: Header.authoriztion.rawValue)
        }
        urlRequest.setValue(serverKey, forHTTPHeaderField: Header.serverKey.rawValue)
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        retrySemaphore.wait(); defer { retrySemaphore.signal() }
        
        guard request.retryCount < retryLimit else {
            completion(.doNotRetryWithError(NetworkError.exceedRetryLimit))
            return
        }
        
        guard let responseData = (request as? DataRequest)?.data else {
            print("DataRequest로 변환되지 않음")
            completion(.doNotRetryWithError(NetworkError.unknownError))
            return
        }
        
        guard let decodedError = try? JSONDecoder().decode(NetworkError.self, from: responseData) else {
            print("CollabeeError가 아님")
            completion(.doNotRetryWithError(NetworkError.unknownError))
            return
        }
        
        print(#function, decodedError.errorDescription ?? "")
        
        // AccessToken Expired
        if let errorCode = decodedError.errorCode, errorCode == "E05" {
            
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                
                isRefreshing = true
                
                TokenStorage.refresh { [weak self] error in
                    
                    if let error {
                        self?.requestsToRetry.forEach {
                            $0(.doNotRetryWithError(error))
                        }
                    } else {
                        self?.requestsToRetry.forEach {
                            $0(.retry)
                        }
                    }
                    
                    self?.requestsToRetry.removeAll()
                    self?.isRefreshing = false
                }
                
            }
            
        } else {
            completion(.doNotRetry)
        }
    }
}
