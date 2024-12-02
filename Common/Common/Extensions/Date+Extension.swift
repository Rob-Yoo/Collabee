//
//  Date+Extension.swift
//  Common
//
//  Created by Jinyoung Yoo on 12/1/24.
//

extension Date {
    public func toServerDateStr() -> String {
        return DateFormatManager.serverDate.string(from: self)
    }
}
