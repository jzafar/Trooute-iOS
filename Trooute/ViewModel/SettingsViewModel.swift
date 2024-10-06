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
    @Published var editCarInfo = false
    private var user: User?
    
    func onAppear(userViewModel: SigninViewModel) {
        self.user = userViewModel.user!
        self.isDriverModeOn = userViewModel.user!.driverMode ?? false
    }
    
    func toggleDriverMode(_ mode: Bool, userViewModel: SigninViewModel) {
        userViewModel.user?.driverMode = mode
    }
}
