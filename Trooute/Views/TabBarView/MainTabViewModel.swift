//
//  MainTabViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

import Firebase
import Foundation
import SwiftUI

class MainTabViewModel: ObservableObject {
//    @AppStorage(UserDefaultsKey.user.key) var user: User?
    private let repositiry = MainTabViewRepository()
    func getMe() {
        repositiry.getMe { [weak self] result in
            switch result {
            case let .success(response):
                if response.data.success,
                   let user = response.data.data {
                    UserUtils.shared.saveUserToStorage(user: user)
//                    guard let self = self else { return }
//                    self.updateToken()
                }

            case let .failure(error):
                log.error("failed to get me \(error.localizedDescription)")
            }
        }
    }

    func updateToken() {
        if let fcm = Messaging.messaging().fcmToken {
            repositiry.updateDeviceId(request: UpdateDeviceIDRequest(deviceId: fcm)) { result in
                switch result {
                case let .success(success):
                    log.info("Device token uploaded status \(success.data.message)")
                case let .failure(failure):
                    log.error("Device token uploaded status \(failure.localizedDescription)")
                }
            }
        }
    }
}
