//
//  Notifications.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-27.
//
import Foundation
import UserNotifications
import Firebase
struct Notifications {
    let userModel: UserUtils = UserUtils.shared
    private let repositiry = NotificationsRepository()
    
    func sendNotification(title: String, body: String, toId: String, mutableContent: Bool = true, data: NotificationRequest.Data? = nil, completion: @escaping (Result<Response<Bool>, Error>) -> Void) {
        let notificationRequest = NotificationRequest(
            notification: NotificationRequest.Notification(
                title: title,
                body: body,
                mutableContent: mutableContent
            ),
            to: "\(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(toId)",
            data: data
        )
        NotificationsRepository().sendMessageNotification(request: notificationRequest, completion: completion)
    }
    
    func subscribeTopic(topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error = error {
                    log.error("Failed to subscribe to topic \(topic): \(error.localizedDescription)")
                    completion(error)
                } else {
                    log.info("Successfully subscribed to topic \(topic)")
                    completion(nil)
                }
            }
    }
    
    func unsubscribeTopic(topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                log.error("Failed to unsubscribeTopic to topic \(topic): \(error.localizedDescription)")
                completion(error)
            } else {
                log.info("Successfully unsubscribeTopic to topic \(topic)")
                completion(nil)
            }
        }
    }
}

extension UNUserNotificationCenter {
    static func notificationsAllowed() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        return !(settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied)
    }

    static func askForNotificationPermissions() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print(error)
        }
    }
}

class NotificationsRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func sendMessageNotification(request: NotificationRequest, completion: @escaping (Result<Response<Bool>, Error>) -> Void) {
        self.networkService.request(url: Apis.FCM_BASE_URL, method: .POST, httpBody: request.toDictionary(), isFireBase: true, completion: completion)
    }
}
