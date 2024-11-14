//
//  TroouteApp.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-14.
//

import Firebase
import SwiftUI
import UserNotifications

let log = Logs.self
@main
struct TroouteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var user = UserUtils.shared
    @StateObject var fireBase = FirebaseViewModel()
    init() {
//        UITabBar.appearance().backgroundColor = UIColor(Color("TitleColor"))
//        UITabBar.appearance().barTintColor = UIColor(Color("TitleColor"))
//        UITabBar.appearance().unselectedItemTintColor = .white
//        UITabBar.appearance().stackedLayoutAppearance.selected.iconColor = .white

//        let appearance = UITabBarAppearance()
//
//        // Set custom colors for selected and unselected tab items
//        appearance.stackedLayoutAppearance.selected.iconColor = .white // Selected icon color
//        appearance.stackedLayoutAppearance.normal.iconColor = .white // Unselected icon color
//        appearance.stackedItemWidth = 50
//
//        // Set the TabBar background color
//        appearance.backgroundColor = UIColor(Color("TitleColor"))
//
//        // Apply the appearance to UITabBar
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(fireBase)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = Logs()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Device token: ", fcmToken ?? "is nill")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("didFailToRegisterForRemoteNotificationsWithError \(error.localizedDescription)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }

        print(userInfo)

        completionHandler()
    }
}
