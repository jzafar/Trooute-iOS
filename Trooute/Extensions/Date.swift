//
//  Date.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
