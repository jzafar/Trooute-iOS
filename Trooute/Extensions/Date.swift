//
//  Date.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//

import Foundation

extension Date {
    func mediumFormatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    func fullFormatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func shotFormate() -> String { //"2024-02-27"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func toTimeString() -> String { //"04:30 pm"
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
    
}
extension TimeInterval {
    func formatTimeInterval() -> String {
        let date = Date(timeIntervalSince1970: self)
        let now = Date()
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            return timeFormatter.string(from: date)
            
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
            
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            return dayFormatter.string(from: date)
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
    }
}
