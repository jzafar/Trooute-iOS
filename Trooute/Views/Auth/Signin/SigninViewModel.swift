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
                    switch result {
                    case .success(let response):
                        if response.data.success,
                           let user = response.data.data,
                           let token = response.data.token {
                            self?.saveUserToStorage(user: user, token: token)
                        } else if (response.statusCode == 205) {
                            self?.showVerificationCodeView = true
                        } else {
                            BannerHelper.displayBanner(.error, message:  response.data.message)
                        }
                            
                    case .failure(let error):
                        log.error("login failed \(error.localizedDescription)")
                        BannerHelper.displayBanner(.error, message:  error.localizedDescription)
                    }
                }
            
        }
    }

    func logout() {
        clearUserFromStorage()
    }

    func onAppear() {
        self.email = ""
        self.password = ""
        self.isPasswordVisible = false
    }
    
    private func saveUserToStorage(user: User, token: String) {
        let userData = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(userData, forKey: UserDefaultsKey.user.key)
        UserDefaults.standard.set(token, forKey: UserDefaultsKey.token.key)

    }

//    // Load user from UserDefaults
//    private func loadUserFromStorage() {
//        if let userData = UserDefaults.standard.data(forKey: UserDefaultsKey.user.key),
//           let savedUser = try? JSONDecoder().decode(User.self, from: userData) {
//
//        }
//    }

    // Clear user data from UserDefaults
    private func clearUserFromStorage() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.user.key)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.token.key)
    }
}
