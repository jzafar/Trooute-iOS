//
//  MainTabView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI
import CustomTabView

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var hide: Bool = false
    private var tabBarView: SampleTabBarView {
        SampleTabBarView(selection: $selectedTab, hide: $hide) { _ in
            print("Enjoying a custom TabView")
        }
    }

    var body: some View {
        CustomTabView(tabBarView: tabBarView, tabs: Tab.allCases, selection: selectedTab) {
            NavigationStack {
                TripsView()
                    .navigationBarTitle("Ongoing Trips")
            }

            NavigationView {
                InboxView()
                    .navigationBarTitle("Inbox")
            }

            NavigationView {
                BookingsView()
                    .navigationBarTitle("Bookings")
            }

            NavigationStack {
                SettingsView()
                    .navigationBarTitle("Settings")
            }
        }
//        .edgesIgnoringSafeArea(.top) // <--- Here
//        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    MainTabView()
}
