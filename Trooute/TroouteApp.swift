//
//  TroouteApp.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-14.
//

import SwiftUI

@main
struct TroouteApp: App {
    @StateObject var userViewModel = SigninViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
        }
    }
}
