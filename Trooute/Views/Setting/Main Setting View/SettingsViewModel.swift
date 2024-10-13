//
//  SettingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import Foundation
import SwiftUI
class SettingsViewModel: ObservableObject {
    @Published var isDriverModeOn = true
    @Published var isNotificationOn = true
    @Published var editCarInfo = false
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    init() {
        if let user = self.user {
            self.isDriverModeOn = user.driverMode ?? false
        }
    }
    
    
    func toggleDriverMode(_ mode: Bool) {
        user?.driverMode = mode
    }
}
