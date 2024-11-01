//
//  Message.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//
import Foundation

struct Message: Codable, Identifiable, Hashable {
    var id: String
    let senderId: String
    let message: String
    let timestamp: TimeInterval
}
