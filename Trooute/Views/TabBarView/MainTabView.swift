//
//  MainTabView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var fireBaseVM :  FirebaseViewModel
    @State private var selectedTab: Tab = .home
    private var viewModel = MainTabViewModel()
    private var tabBarView: TabBarView {
        TabBarView(selection: $selectedTab) { selectedtab in
            Tabbar.shared.selectedTab = selectedtab
        }
    }

    var body: some View {
        CustomTabView(tabBarView: tabBarView, tabs: Tab.allCases, selection: selectedTab) {
            NavigationStack {
                TripsView()
                    .onAppear {
                        Tabbar.shared.hide = false
                    }
            }

            NavigationView {
                InboxView()
                    .onAppear {
                        Tabbar.shared.hide = false
                        Tabbar.shared.hasNewMessage = false
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
                        viewModel.getMe()
                    }
            }
        }
        .onAppear {
            viewModel.getMe()
            if let id = UserUtils.shared.user?.id {
                fireBaseVM.getAllInbox(userId: id)
            }
        }
    }
}

//#Preview {
//    MainTabView()
//}
