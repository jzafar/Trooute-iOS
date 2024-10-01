//
//  MainTabView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    private var tabBarView: TabBarView {
        TabBarView(selection: $selectedTab) { _ in
            print("Enjoying a custom TabView")
        }
    }

    var body: some View {
        CustomTabView(tabBarView: tabBarView, tabs: Tab.allCases, selection: selectedTab) {
            NavigationStack {
                TripsView()
                    .onAppear {
                        Tabbar.shared.hide = false
                    }
                    .navigationBarTitle("Ongoing Trips")
            }

            NavigationView {
                InboxView()
                    .onAppear {
                        Tabbar.shared.hide = false
                    }
                    .navigationBarTitle("Inbox")
            }

            NavigationView {
                BookingsView()
                    .onAppear {
                        Tabbar.shared.hide = false
                    }
                    .navigationBarTitle("Bookings")
            }

            NavigationStack {
                SettingsView()
                    .navigationBarTitle("Settings")
                    .onAppear {
                        Tabbar.shared.hide = false
                    }
            }
        }
//        .edgesIgnoringSafeArea(.top) // <--- Here
//        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    MainTabView()
}
