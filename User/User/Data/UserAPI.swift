//
//  UserAPI.swift
//  User
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import DataSource

enum UserAPI {
    case getMyProfile
    case editMyProfile(ProfileBody)
    case editMyProfileImage(MultipartFormData)
    case getMemberProfile(_ userID: String)
}

extension UserAPI: API {
    var path: String {
        switch self {
        case .getMyProfile, .editMyProfile:
            return "/v1/users/me"
        case .editMyProfileImage:
            return "/v1/users/me/image"
        case .getMemberProfile(let userID):
            return "/v1/users/\(userID)"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .getMyProfile:
            return .get
        case .editMyProfile:
            return .put
        case .editMyProfileImage:
            return .put
        case .getMemberProfile:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getMyProfile:
            return .requestPlain
        case .editMyProfile(let body):
            return .requestWithEncodableBody(body)
        case .editMyProfileImage(let formData):
            return .uploadMultipart([formData])
        case .getMemberProfile:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMyProfile, .getMemberProfile:
            return nil
        case .editMyProfile:
            return [ Header.contentType.rawValue: Header.json.rawValue ]
        case .editMyProfileImage:
            return [ Header.contentType.rawValue: Header.multipart.rawValue ]
        }
    }
}
