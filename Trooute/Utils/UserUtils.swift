//
//  UserUtils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//
import Foundation
import SwiftUI

class UserUtils: ObservableObject {
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @AppStorage(UserDefaultsKey.token.key) var token: String?
    @Published var token1: String?
    @Published var driverStatus: DriverStatus = .unknown
    @Published var driverMode: Bool = false
    private var _driverState : String {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.driverState.key)
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.driverState.key) ?? "unknown"
        }
    }
    static var shared = UserUtils()
    init() {
        self.token1 = token
        let driverState = UserDefaults.standard.string(forKey: UserDefaultsKey.driverState.key) ?? "unknown"
        self.driverStatus = DriverStatus(from: driverState)
        self.driverMode = drivMode
    }
    private var drivMode: Bool {
        set {
            self.driverMode = newValue
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.driverMode.key)
        } get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.driverMode.key)
        }
    }
    
    var stripeToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.stripeToken.key)
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.stripeToken.key)
        }
    }
    
    func saveUserToStorage(user: User, token: String) {
        self.user = user
        self.token = token
        self.token1 = token
        if let mode = user.driverMode {
            self.drivMode = mode
        }
        if let status = user.isApprovedDriver {
            self.driverStatus = DriverStatus(from: status)
        }
    }

    func clearUserFromStorage() {
        self.user = nil
        self.token = nil
        self.token1 = nil
        self.drivMode = false
        self.driverStatus = .unknown
        self._driverState = "unknown"
        self.stripeToken = nil
    }
    
    func saveUserToStorage(user: User) {
        self.user = user
        if let mode = user.driverMode {
            self.drivMode = mode
        }
        if let status = user.isApprovedDriver {
            self._driverState = status
            self.driverStatus = DriverStatus(from: status)
        }
        if let stripeToken = user.stripeToken {
            self.stripeToken = stripeToken
        }
        
    }
    
    func updateDriverMode() {
        self.user?.driverMode = !driverMode
        drivMode = !driverMode
    }
    
    func updateCarInfo(car: CarDetails) {
        self.user?.carDetails = car
    }
}
