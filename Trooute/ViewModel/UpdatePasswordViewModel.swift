//
//  UpdatePasswordViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Foundation

class UpdatePasswordViewModel: ObservableObject {
    @Published var showCurrentPassword = false
    @Published var currentPassword = ""
    @Published var showPassword = false
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showConfirmPassword = false
}
