//
//  UpdateProfileViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//
import SwiftUI
class UpdateProfileViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var phoneNumber = ""
    @Published var updatePassword = false
    @Published var useImage: Image? = nil
}
