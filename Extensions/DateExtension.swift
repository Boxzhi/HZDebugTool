//
//  DateExtension.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/2.
//

extension Date {
    
    public func dateFormatString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = dateFormat
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.calendar = Calendar(identifier: .iso8601)
        // 格式为"yyyy-MM-dd HH:mm:ss"的当前时间
        let nowTimeString = timeFormatter.string(from: self)
        return nowTimeString
    }
    
}
