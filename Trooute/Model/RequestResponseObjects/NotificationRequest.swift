//
//  NotificationRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-09.
//
import Foundation
struct NotificationRequest: Codable {
    var notification: Notification?
    var to: String
    var data: Data?

    struct Data: Codable {
        var dl: String?
        var url: String?
    }

    struct Notification: Codable {
        var title: String
        var body: String
        var mutableContent: Bool
        var sound: String = "default"
    }
}
