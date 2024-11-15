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
    @Published var userModel: UserUtils = UserUtils.shared
    

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
                    BannerHelper.displayBanner(.info, message: String(localized:"You have enabled notifications but notifications are off from settings. Please go to application settings and enable notifications"))
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

    func getMe() {
        self.repository.getMe { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                if response.data.success,
                let user = response.data.data {
                    self.userModel.user = user
                }
            case .failure(let failure):
                log.error("get me \(failure.localizedDescription)")
            }
        }
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
        SwiftLoader.show(title: String(localized:"Logout..."), animated: true)
        self.repository.signout(request: SignoutRequest(deviceId: Utils.getToken() ?? "")) { [weak self] result in
            
            guard let self = self else {return}
            self.notificationTopic(subscribed: false, logout: true)
        }
        
    }
    
    private func notificationTopic(subscribed: Bool, logout: Bool = false) {
        if let userId = UserUtils.shared.user?.id {
            let notifications = Notifications()
            if subscribed {
                notifications.subscribeTopic(topic: Apis.TROOUTE_TOPIC + userId) { error in
                    log.info("subscribeTopic to \(userId) error \(String(describing: error?.localizedDescription))")
                }
            } else {
                notifications.unsubscribeTopic(topic: Apis.TROOUTE_TOPIC + userId) { error in
                    log.info("unsubscribeTopic to \(userId) error \(String(describing: error?.localizedDescription))")
                    if logout {
                        UserUtils.shared.clearUserFromStorage()
                    }
                    SwiftLoader.hide()
                }
            }
        }
    }

    func sendEmail() {
        EmailController.shared.sendEmail(subject: "", body: "", to: "support@trooute.com")
    }

    func actionSheet() {
        let data = String(localized:"Hey! I want to invite you to try Trooute App. Get where you’re going with affordable, convenient rides. You can download App from this link: https://apps.apple.com/us/app/trooute/id6737987619")
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
