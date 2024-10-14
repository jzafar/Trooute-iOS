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
}
