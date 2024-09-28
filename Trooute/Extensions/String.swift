//
//  String.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//
import Foundation
extension String {
    func fullFormate() -> String {
        print(self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date.fullFormatDate()
        }
       
//        if let date = dateFormatter.date(from: self) {
//            return date.fullFormatDate()
//        }
        return "Unknown date"
    }
}
