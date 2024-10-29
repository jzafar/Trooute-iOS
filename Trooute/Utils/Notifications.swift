//
//  Notifications.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-27.
//
import Foundation
import UserNotifications
class Notifications {
   
}
extension UNUserNotificationCenter {
    static func notificationsAllowed() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        return !(settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied)
    }
}
