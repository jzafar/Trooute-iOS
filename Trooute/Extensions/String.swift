//
//  String.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//
import Foundation
extension String {
    func fullFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date.fullFormatDate()
        }
        return "Unknown date"
    }

    func find(_ char: Character) -> Index? {
        return self.firstIndex(of: char)
    }
    
    func firstTenCharacters() -> String {
        return String(prefix(10)).uppercased()
    }

    func replace(_ replace: String, withString: String, caseSensitive: Bool) -> String {
        if caseSensitive {
            return replacingOccurrences(of: replace, with: withString)
        } else {
            return replacingOccurrences(of: replace, with: withString, options: .caseInsensitive)
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var firstCapitalized: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
}

extension Optional where Wrapped == String {
    var emptyOrNil: String {
        return self?.isEmpty == false ? self! : "Not Provided"
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

extension Notification {
    static let ReviewPosted = Notification.Name.init("ReviewPosted")
}
