//
//  SettingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var isDriverModeOn = true
    @Published var isNotificationOn = true
    
    var user: User
    init() {
        let loginResponse = MockDate.getLoginResponse()
        self.user = loginResponse!.data!
        self.isDriverModeOn = self.user.driverMode ?? false
    }
    
    var driverModeOn: Bool {
        return user.driverMode ?? false
    }
    
    var carDetails: CarDetails? {
        return user.carDetails
    }
    
    func toggleDriverMode(_ mode: Bool) {
        self.user.driverMode = mode
    }
}
