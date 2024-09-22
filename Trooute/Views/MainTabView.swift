//
//  MainTabView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

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
                    .onDisappear {
                        hide = true
                    }.onAppear {
                        hide = false
                    }
                    .navigationBarTitle("Ongoing Trips")
            }

            NavigationView {
                InboxView()
                    .onDisappear {
                        hide = true
                    }.onAppear {
                        hide = false
                    }
                    .navigationBarTitle("Inbox")
            }

            NavigationView {
                BookingsView()
                    .onDisappear {
                        hide = true
                    }.onAppear {
                        hide = false
                    }
                    .navigationBarTitle("Bookings")
            }

            NavigationStack {
                SettingsView()
                    .navigationBarTitle("Settings")
                    .onDisappear {
                        hide = true
                    }.onAppear {
                        hide = false
                    }
            }
        }
//        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    MainTabView()
}
