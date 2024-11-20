//
//  APIMapper.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/16/24.
//

import Moya

struct APIAdapter: TargetType {
    private let api: API

    init(api: API) {
        self.api = api
    }

    var baseURL: URL {
        return api.baseURL
    }

    var path: String {
        return api.path
    }

    var method: Moya.Method {
        switch api.method {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }

    var task: Task {
        switch api.task {
        case .requestPlain:
            return .requestPlain
        case .requestWithRawBody(let body):
            return .requestData(body)
        case .requestWithEncodableBody(let body):
            return .requestJSONEncodable(body)
        case .requestQueryParameters(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .uploadMultipart(let dataArray):
            return .uploadMultipart(dataArray.map {
                Moya.MultipartFormData(
                    provider: .data($0.data),
                    name: $0.name,
                    fileName: $0.fileName,
                    mimeType: $0.mimeType)
            })
        }
    }

    var headers: [String: String]? {
        return api.headers
    }
}
