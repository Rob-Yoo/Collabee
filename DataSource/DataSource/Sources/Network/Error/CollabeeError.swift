//
//  CollabeeError.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Combine

public enum CollabeeError: Decodable, LocalizedError {
    case apiError(String)
    case unknownError

    private enum CodingKeys: String, CodingKey {
        case errorCode
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let errorCode = try? container.decode(String.self, forKey: .errorCode) {
            self = .apiError(errorCode)
        } else {
            self = .unknownError
        }
    }

    public var errorDescription: String? {
        switch self {
        case .apiError(let code):
            return Self.descriptionForErrorCode(code)
        case .unknownError:
            return "An unknown error occurred."
        }
    }
    
    var errorCode: String? {
        switch self {
        case .apiError(let code):
            return code
        case .unknownError:
            return nil
        }
    }

    private static func descriptionForErrorCode(_ code: String) -> String {
        switch code {
        case "E01": return "접근 권한이 없습니다."
        case "E02": return "토큰 인증에 실패하였습니다."
        case "E03": return "서버에 등록되지 않은 계정입니다."
        case "E05": return "액세스 토큰이 만료 되었습니다."
        case "E11": return "잘못된 요청입니다. 요청 파라미터나 바디를 확인해주세요."
        case "E12": return "중복 데이터입니다."
        case "E13": return "서버에 존재하지 않는 데이터입니다."
        case "E14": return "관리자 권한이 없습니다."
        case "E15": return "관리자 권한이 있는 경우 퇴장할 수 없습니다."
        case "E81": return "중복된 결제건입니다."
        case "E82": return "유효하지 않은 결제건입니다."
        case "E97": return "잘못된 라우터 경로입니다."
        case "E98": return "서버 요청을 과호출하였습니다."
        case "E99": return "서버 오류입니다."
        default: return "등록되지 않은 오류 코드: \(code)."
        }
    }
}
