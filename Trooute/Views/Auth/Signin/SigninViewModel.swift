//
//  SigninViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import Foundation
import SwiftLoader
import SwiftUI
class SigninViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var showForgetPassword = false
    @Published var showSignupView = false
    @Published var showAlert = false
    @Published var showVerificationCodeView = false
    private let repository = SigninRepository()
    
    func loginButtonPress() {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            BannerHelper.displayBanner(.error, message: "Email field can't be empty.")
            return
        } else if password.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            BannerHelper.displayBanner(.error, message: "Password field can't be empty.")
            return
        } else {
            let loginRequest = SigninRequest(email: email, password: password)
            SwiftLoader.show(title: "Signin...", animated: true)
            repository.signin(signinRequest: loginRequest) { [weak self] result in
                SwiftLoader.hide()
                guard let self = self else {return}
                    switch result {
                    case .success(let response):
                        if response.data.success,
                           let user = response.data.data,
                           let token = response.data.token {
                            UserUtils.shared.saveUserToStorage(user: user, token: token)
                            self.subscribeTopic(userId: user.id)
                        } else if (response.statusCode == 205) {
                            self.showVerificationCodeView = true
                        } else {
                            BannerHelper.displayBanner(.error, message:  response.data.message)
                        }
                            
                    case .failure(let error):
                        BannerHelper.displayBanner(.error, message:  error.localizedDescription)
                    }
                }
            
        }
    }
    
    private func subscribeTopic(userId: String) {
        let notifications = Notifications()
        notifications.subscribeTopic(topic: Apis.TROOUTE_TOPIC + userId) { error in
            log.info("subscribeTopic to \(Apis.TROOUTE_TOPIC + userId) error \(String(describing: error?.localizedDescription))")
        }
    }

    func onAppear() {
        self.email = ""
        self.password = ""
        self.isPasswordVisible = false
    }
}
