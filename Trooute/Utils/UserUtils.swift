//
//  UserUtils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//
import Foundation

struct UserUtils {
    static func saveUserToStorage(user: User, token: String) {
        let userData = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(userData, forKey: UserDefaultsKey.user.key)
        UserDefaults.standard.set(token, forKey: UserDefaultsKey.token.key)

    }

    static func clearUserFromStorage() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.user.key)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.token.key)
    }
    
    static func saveUserToStorage(user: User) {
        let userData = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(userData, forKey: UserDefaultsKey.user.key)
    }
}
