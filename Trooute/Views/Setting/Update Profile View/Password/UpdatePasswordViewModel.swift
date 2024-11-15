//
//  UpdatePasswordViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Foundation
import SwiftLoader
import SwiftUI

class UpdatePasswordViewModel: ObservableObject {
    @Published var showCurrentPassword = false
    @Published var currentPassword = ""
    @Published var showPassword = false
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showConfirmPassword = false
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @AppStorage(UserDefaultsKey.token.key) var token: String?
    private let repository = UpdatePasswordRepository()
    
    
    func updatePasswordPressed() {
        if currentPassword.count == 0 {
            BannerHelper.displayBanner(.error, message: String(localized:"Password can't be blank"))
        } else if (password.count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Retype your password. It can't be blank"))
        }
        else if (confirmPassword.count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Retype your password. It can't be blank"))
        } else if Utils.matchPassword(confirmPassword, password) {
            BannerHelper.displayBanner(.error, message: String(localized:"Passwords did not matched"))
        } else if (confirmPassword.count < 8) {
            BannerHelper.displayBanner(.error, message: String(localized:"Password needs to consist of at least 8 characters"))
        } else {
            SwiftLoader.show(title: String(localized:"Updating..."), animated: true)
            repository.updatePassword(request: UpdatePasswordRequest(password: password, passwordConfirm: confirmPassword, passwordCurrent: currentPassword)) { result in
                SwiftLoader.hide()
                    switch result {
                    case .success(let response):
                        if response.data.success,
                           let user = response.data.data,
                           let token = response.data.token {
                            self.token = token
                            self.user = user
                            BannerHelper.displayBanner(.success, message: String(localized:"Password Updated successfully"))
                        } else {
                            BannerHelper.displayBanner(.error, message:  response.data.message)
                        }
                            
                    case .failure(let error):
                        BannerHelper.displayBanner(.error, message:  error.localizedDescription)
                    }
                }
        }
    }
    
}
