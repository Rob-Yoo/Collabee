//
//  AccessTokenRetrier.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Alamofire
import Combine

final class TokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        guard let serverKey = Literal.Secret.ServerKey else { return }

//        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYjc1Yzg3YjEtMGIzZS00NGJiLWFiNmUtMWRiZWY2NTUzM2RlIiwibmlja25hbWUiOiLsp4DribQiLCJpYXQiOjE3MzEwMzkzNTYsImV4cCI6MTczMTAzOTY1NiwiaXNzIjoic2xwIn0.zmlI7SM2PtnDnP6G1tT1ULjBK6rg7JnAkeARWM1pn3A"
        if let accessToken = TokenStorage.read(.access) {
            urlRequest.setValue(accessToken, forHTTPHeaderField: Header.authoriztion.rawValue)
        }
        urlRequest.setValue(serverKey, forHTTPHeaderField: Header.serverKey.rawValue)
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let responseData = (request as? DataRequest)?.data else {
            print("DataRequest로 변환되지 않음")
            completion(.doNotRetryWithError(CollabeeError.unknownError))
            return
        }
        
        guard let decodedError = try? JSONDecoder().decode(CollabeeError.self, from: responseData) else {
            print("CollabeeError가 아님")
            completion(.doNotRetryWithError(CollabeeError.unknownError))
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
