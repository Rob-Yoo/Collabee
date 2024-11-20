//
//  ServerKeyAdapter.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/19/24.
//

import Alamofire

struct ServerKeyAdapter: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        guard let serverKey = Literal.Secret.ServerKey else { return }
        urlRequest.setValue(serverKey, forHTTPHeaderField: Header.serverKey.rawValue)
        completion(.success(urlRequest))
    }
}
