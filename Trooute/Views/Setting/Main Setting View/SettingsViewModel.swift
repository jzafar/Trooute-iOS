//
//  SettingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import Foundation
import SwiftUI
import SwiftLoader
import MessageUI

class SettingsViewModel: ObservableObject {
    @Published var isDriverModeOn = true
    @Published var isNotificationOn = false
    @Published var editCarInfo = false
    
    var isUserInteractionWithSwitch: Bool = true
    private let repository = SettingsRepository()
    
    init() {
        self.setDriverMode()
        self.getNotificationPermission()
    }
    
    func setDriverMode() {
        self.isDriverModeOn = UserUtils.shared.driverMode
    }
    
    func toggleDriverMode(userIntrection: Bool) {
        if userIntrection {
            isUserInteractionWithSwitch = false
            SwiftLoader.show(animated: true)
            repository.switchDriverMode { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success {
                        UserUtils.shared.updateDriverMode()
                    } else {
                        self?.setDriverMode()
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case .failure(let failure):
                    self?.setDriverMode()
                    BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                }
                self?.isUserInteractionWithSwitch = true
            }
        }
    }
    func logoutPressed() {
        UserUtils.shared.clearUserFromStorage()
    }
    
    func sendEmail() {
        EmailController.shared.sendEmail(subject: "", body: "", to: "support@trooute.com")
    }
    
    func actionSheet() {
        let data = "Hey! I want to invite you to try Trooute App. Get where you’re going with affordable, convenient rides. You can download App from this link: https://play.google.com/store/apps/details?id=com.travel.trooute"
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        Utils.getRootViewController()?.present(av, animated: true, completion: nil)
    }
    
    private func getNotificationPermission() {
         Task {
             let notificationsAllowed = await UNUserNotificationCenter.notificationsAllowed()
             withAnimation {
                 DispatchQueue.main.async {
                     self.isNotificationOn = notificationsAllowed
                 }
             }
         }
     }
}
