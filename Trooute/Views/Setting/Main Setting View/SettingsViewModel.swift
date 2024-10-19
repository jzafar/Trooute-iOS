//
//  SettingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import Foundation
import SwiftUI
import SwiftLoader

class SettingsViewModel: ObservableObject {
    @Published var isDriverModeOn = true
    @Published var isNotificationOn = false
    @Published var editCarInfo = false
    var isUserInteractionWithSwitch: Bool = true
    private let repository = SettingsRepository()
    
    init() {
        self.setDriverMode()
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
}
