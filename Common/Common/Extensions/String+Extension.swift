//
//  String+Extension.swift
//  Common
//
//  Created by Jinyoung Yoo on 12/1/24.
//

extension String {
    
    public func toServerDate() -> Date {
        let serverDate = DateFormatManager.serverDate.date(from: self) ?? Date()
        return serverDate
    }
    
    public func isToday() -> Bool {
        let date = self.toServerDate()
        return Calendar.current.isDateInToday(date)
    }

    public func toChatTime() -> String {
        let serverDate = self.toServerDate()
        let chatTime = DateFormatManager.chatTime.string(from: serverDate)
        return chatTime
    }
    
    public func toChatDate() -> String {
        let serverDate = self.toServerDate()
        let chatDateTime = DateFormatManager.chatDate.string(from: serverDate)
        return chatDateTime
    }
}
