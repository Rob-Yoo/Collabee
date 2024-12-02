//
//  DateFormatManager.swift
//  Common
//
//  Created by Jinyoung Yoo on 12/1/24.
//

import Foundation

enum DateFormatManager {
    enum DateFormat: String {
        case chatTime = "hh:mm a"
        case chatDate = "M/dd"
    }
    
    static let serverDate = {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return iso8601DateFormatter
    }()
    
    static let chatTime = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.chatTime.rawValue
        dateFormatter.locale = Locale(identifier: "ko-KR")
        return dateFormatter
    }()
    
    static let chatDate = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.chatDate.rawValue
        dateFormatter.locale = Locale(identifier: "ko-KR")
        return dateFormatter
    }()
}
