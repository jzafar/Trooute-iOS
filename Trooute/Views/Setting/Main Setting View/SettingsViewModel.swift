//
//  SettingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import Foundation
import MessageUI
import SwiftLoader
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage(UserDefaultsKey.isNotificationEnabled.key) var isNotificationOn: Bool = false
    @Published var isDriverModeOn = true
    @Published var editCarInfo = false
    var isUserInteractionWithSwitch: Bool = true
    private let repository = SettingsRepository()

    init() {
        setDriverMode()
        log.info("isNotificationOn \(isNotificationOn)")
    }

    func onAppear() {
        Task {
            await askForNotificationPermissions()
            if isNotificationOn {
                let permission = await getNotificationPermission()
                if !permission {
                    BannerHelper.displayBanner(.info, message: "You have enabled notifications but notifications are off from settings. Please go to application settings and enable notifications")
                }
            }
        }
    }

    func onChangeOfNotification() {
        onAppear()
        self.notificationTopic(subscribed: isNotificationOn)
    }

    func setDriverMode() {
        isDriverModeOn = UserUtils.shared.driverMode
    }

    func toggleDriverMode(userIntrection: Bool) {
        if userIntrection {
            isUserInteractionWithSwitch = false
            SwiftLoader.show(animated: true)
            repository.switchDriverMode { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case let .success(response):
                    if response.data.success {
                        UserUtils.shared.updateDriverMode()
                    } else {
                        self?.setDriverMode()
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case let .failure(failure):
                    self?.setDriverMode()
                    BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                }
                self?.isUserInteractionWithSwitch = true
            }
        }
    }

    func logoutPressed() {
        self.notificationTopic(subscribed: false, logout: true)
    }
    
    private func notificationTopic(subscribed: Bool, logout: Bool = false) {
        if let userId = UserUtils.shared.user?.id {
            let notifications = Notifications()
            if subscribed {
                notifications.subscribeTopic(topic: Apis.TROOUTE_TOPIC + userId) { error in
                    log.info("subscribeTopic to \(userId) error \(String(describing: error?.localizedDescription))")
                }
            } else {
                if logout {
                    SwiftLoader.show(title: "Logout...", animated: true)
                }
                notifications.unsubscribeTopic(topic: Apis.TROOUTE_TOPIC + userId) { error in
                    SwiftLoader.hide()
                    log.info("unsubscribeTopic to \(userId) error \(String(describing: error?.localizedDescription))")
                    if logout {
                        UserUtils.shared.clearUserFromStorage()
                    }
                }
            }
        }
    }

    func sendEmail() {
        EmailController.shared.sendEmail(subject: "", body: "", to: "support@trooute.com")
    }

    func actionSheet() {
        let data = "Hey! I want to invite you to try Trooute App. Get where you’re going with affordable, convenient rides. You can download App from this link: https://play.google.com/store/apps/details?id=com.travel.trooute"
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        Utils.getRootViewController()?.present(av, animated: true, completion: nil)
    }

    private func getNotificationPermission() async -> Bool {
        return await UNUserNotificationCenter.notificationsAllowed()
    }

    private func askForNotificationPermissions() async {
        await UNUserNotificationCenter.askForNotificationPermissions()
    }
}
