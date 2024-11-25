//
//  ImageAPI.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/24/24.
//

public enum ImageAPI {
    case load(_ imagePath: String, _ etag: String)
}

extension ImageAPI: API  {
    public var path: String {
        switch self {
        case .load(let imagePath, _):
            return "/v1" + imagePath
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .load:
            return .get
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .load:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .load(_, let etag):
            if !etag.isEmpty {
                return [
                    Header.ifNoneMatch.rawValue: etag
                ]
            }
            
            return nil
        }
    }
    
}
