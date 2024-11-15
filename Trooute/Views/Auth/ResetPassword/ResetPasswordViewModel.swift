//
//  ResetPasswordViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import Foundation
import SwiftLoader

class ResetPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var emailSend = false
    private let repository = ResetPasswordRepository()
    func resetPassword() {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            BannerHelper.displayBanner(.error, message: String(localized:"Email can't be blank."))
            return
        } else if !Utils.isValidEmail(email) {
            BannerHelper.displayBanner(.error, message: String(localized:"Email is not valid"))
            return
        } else {
            SwiftLoader.show(title: String(localized:"Requesting..."), animated: true)
            repository.resetPassword(request: ResetPasswordRequest(email: email)) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case let .success(response):
                    if response.data.success {
                        self?.emailSend = true
                        BannerHelper.displayBanner(.success, message: response.data.message)
                    } else {
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case let .failure(error):
                    BannerHelper.displayBanner(.error, message: error.localizedDescription)
                }
            }
        }
    }
}
