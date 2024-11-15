//
//  VerificationViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

import Foundation
import SwiftLoader
import SwiftUI

class VerificationViewModel: ObservableObject {
    @Published var code: [String] = Array(repeating: "", count: 4)
    @Published var countdown: Int = 30
    @Published var isResendEnabled: Bool = false
    @Published var email: String
    @Published var verified = false
    private let repository = VerificationRepository()
    init(email: String) {
        self.email = email
    }

    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                timer.invalidate()
                self.isResendEnabled = true
            }
        }
    }

    func resendCode() {
        code = Array(repeating: "", count: 4)
        countdown = 30
        isResendEnabled = false
        startCountdown()
    }

    var isCodeComplete: Bool {
        return code.allSatisfy { $0.count == 1 && $0.rangeOfCharacter(from: .decimalDigits) != nil }
    }

    var completeCode: String {
        return code.joined()
    }

    func submitBtnPressed() {
        if !isCodeComplete {
            BannerHelper.displayBanner(.error, message: String(localized:"Code field can't be blank"))
            return
        } else {
            SwiftLoader.show(title: String(localized:"verifying..."), animated: true)
            repository.verifyOTP(otp: OTPVerificationRequest(OTP: completeCode)) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case let .success(response):
                    if response.data.success {
                        self?.verified = true
                        BannerHelper.displayBanner(.success, message: response.data.message)
                    } else {
                        self?.code = Array(repeating: "", count: 4)
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case let .failure(error):
                    BannerHelper.displayBanner(.error, message: error.localizedDescription)
                }
            }
        }
    }

    func resendOTP() {
        SwiftLoader.show(title: String(localized:"Resending..."), animated: true)
        repository.resendOTP(resendOtp: ResendOTPRequest(email: email)) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success {
                    self?.resendCode()
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
