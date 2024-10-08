//
//  TroouteApp.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-14.
//

import SwiftUI
import FirebaseCore

@main
struct TroouteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userViewModel = SigninViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
