//
//  ContentView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-14.
//

import SwiftUI

struct ContentView: View {
    private let isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    @AppStorage(UserDefaultsKey.token.key) var token: String?
    var body: some View {
        if !isFirstLaunch {
            OnboardView()
        } else {
            if token != nil {
                MainTabView()
            } else {
                SigninView()
            }
        }
    }
}

#Preview {
    ContentView()
}
