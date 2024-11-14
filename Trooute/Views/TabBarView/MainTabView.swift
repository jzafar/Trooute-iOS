//
//  MainTabView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var fireBaseVM: FirebaseViewModel
    @State private var selectedTab: Int = 0
    private var viewModel = MainTabViewModel()
//    private var tabBarView: TabBarView {
//        TabBarView(selection: $selectedTab) { selectedtab in
//            Tabbar.shared.selectedTab = selectedtab
//        }
//    }

    @State var path = NavigationPath()
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                NavigationStack(path: $path) {
                    TripsView(path: $path)
                }.tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

                NavigationStack {
                    InboxView()
                        .onAppear {
                            self.fireBaseVM.hasNewMessage = false
                        }
                        .navigationBarTitle("Inbox")
                }.tabItem {
                    Image(systemName: selectedTab == 1 ? "bubble.left.fill" : "bubble.left")
                }
                .tag(1)
                .badge(fireBaseVM.hasNewMessage ? 1 : 0)

                NavigationStack {
                    BookingsView()
                        .onAppear {
                            log.info("selectedTab \(selectedTab)")
                        }
                        .navigationBarTitle("Bookings")
                }.tabItem {
                    Image(systemName: selectedTab == 2 ? "calendar.circle.fill" : "calendar.circle")
                }
                .tag(2)

                NavigationStack {
                    SettingsView()
                        .navigationBarTitle("Settings")
                        .onAppear {
                            viewModel.getMe()
                            print("selectedTab \(selectedTab)")
                        }
                }.tabItem {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                }
                .tag(3)
            }
        }
//        .toolbarBackground(.indigo, for: .tabBar)
//            .toolbarBackground(.visible, for: .tabBar)
//            .toolbarColorScheme(.light, for: .tabBar)

        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                viewModel.getMe()
                viewModel.updateToken()
            }

            if let id = UserUtils.shared.user?.id {
                fireBaseVM.getAllInbox(userId: id)
            }
        } .onChange(of: selectedTab) { value in
            fireBaseVM.seletedTab = value }

    }
}

// #Preview {
//    MainTabView()
// }
