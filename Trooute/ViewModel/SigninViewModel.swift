//
//  SigninViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import Foundation
class SigninViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var showForgetPassword = false
    @Published var showSignupView = false
    @Published var showMainView = false
    
    @Published var token: String? = nil
    @Published var user: User? = nil
    
    init() {
           loadUserFromStorage()
       }
    
    func loginButtonPress() {
        if let loginResponse = MockDate.getLoginResponse() {
            if loginResponse.success {
                self.token = loginResponse.token
                self.user = loginResponse.data
                saveUserToStorage()
                self.showMainView = true
            }
        }
    }
    
    func logout() {
        self.user = nil
        self.token = nil
        clearUserFromStorage()
    }
    
       private func saveUserToStorage() {
           if let user = user {
               let userData = try? JSONEncoder().encode(user)
               UserDefaults.standard.set(userData, forKey: "storedUser")
               UserDefaults.standard.set(token, forKey: "token")
           }
       }

       // Load user from UserDefaults
       private func loadUserFromStorage() {
           if let userData = UserDefaults.standard.data(forKey: "storedUser"),
              let savedUser = try? JSONDecoder().decode(User.self, from: userData) {
               self.user = savedUser
               self.token = UserDefaults.standard.string(forKey: "token")
           }
       }

       // Clear user data from UserDefaults
       private func clearUserFromStorage() {
           UserDefaults.standard.removeObject(forKey: "storedUser")
           UserDefaults.standard.removeObject(forKey: "token")
       }
}
