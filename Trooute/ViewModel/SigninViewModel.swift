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
}
