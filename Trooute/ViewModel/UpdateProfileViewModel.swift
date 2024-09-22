//
//  UpdateProfileViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//
import Foundation
class UpdateProfileViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var phoneNumber = ""
    @Published var updatePassword = false
}
