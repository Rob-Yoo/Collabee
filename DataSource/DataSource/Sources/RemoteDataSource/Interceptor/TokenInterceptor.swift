//
//  AccessTokenRetrier.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Alamofire

struct TokenInterceptor: RequestInterceptor {
    
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
        
        print(decodedError.errorDescription ?? "")
        
        if let errorCode = decodedError.errorCode, errorCode == "E05" {
            TokenStorage.refresh {
                completion(.retry)
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
