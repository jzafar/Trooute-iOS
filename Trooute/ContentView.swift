//
//  ContentView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-14.
//

import SwiftUI

struct ContentView: View {
    private let isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    var body: some View {
        if !isFirstLaunch {
            OnboardView()
        } else {
            SigninView()
        }
    }
}

#Preview {
    ContentView()
}
