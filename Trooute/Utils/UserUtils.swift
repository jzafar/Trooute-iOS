//
//  UserUtils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//
import Foundation
import SwiftUI
struct UserUtils {
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @AppStorage(UserDefaultsKey.token.key) var token: String?
    static let shared = UserUtils()
    func saveUserToStorage(user: User, token: String) {
        self.user = user
        self.token = token
    }

    func clearUserFromStorage() {
        self.user = nil
        self.token = nil
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.user.key)
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.token.key)
    }
    
    func saveUserToStorage(user: User) {
        self.user = user
    }
}
