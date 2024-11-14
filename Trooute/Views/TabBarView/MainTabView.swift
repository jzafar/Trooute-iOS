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
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
//                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .tag(0)

                NavigationStack {
                    InboxView()
                        .onAppear {
                            self.fireBaseVM.hasNewMessage = false
                        }
                        .navigationBarTitle("Inbox")
                }.tabItem {
                    Label("Chat", systemImage: selectedTab == 1 ? "bubble.left.fill" : "bubble.left")
//                    Image(systemName: selectedTab == 1 ? "bubble.left.fill" : "bubble.left")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .tag(1)
                .badge(fireBaseVM.hasNewMessage ? 1 : 0)

                NavigationStack {
                    BookingsView()
                        .navigationBarTitle("Bookings")
                }.tabItem {
                    Label("Bookings", systemImage: selectedTab == 2 ? "calendar.circle.fill" : "calendar.circle")
//                    Image(systemName: selectedTab == 2 ? "calendar.circle.fill" : "calendar.circle")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
                .tag(2)

                NavigationStack {
                    SettingsView()
                        .navigationBarTitle("Settings")
                        .onAppear {
                            viewModel.getMe()
                        }
                }.tabItem {
                    Label("Settings", systemImage: selectedTab == 3 ? "gearshape.fill" : "gearshape")
//                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .tag(3)
            }
        }

        .onAppear {
            
            let standardAppearance = UITabBarAppearance()
            standardAppearance.backgroundColor = UIColor(Color("TitleColor"))

            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = UIColor(.white)
            itemAppearance.selected.iconColor = UIColor(.white)
            standardAppearance.inlineLayoutAppearance = itemAppearance
            standardAppearance.stackedLayoutAppearance = itemAppearance
            standardAppearance.compactInlineLayoutAppearance = itemAppearance
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white
            ]
            standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = selectedAttributes
            standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes


            UITabBar.appearance().standardAppearance = standardAppearance
            UITabBar.appearance().scrollEdgeAppearance = standardAppearance
        }

        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                viewModel.getMe()
                viewModel.updateToken()
            }

            if let id = UserUtils.shared.user?.id {
                fireBaseVM.getAllInbox(userId: id)
            }
        }.onChange(of: selectedTab) { value in
            fireBaseVM.seletedTab = value
        }
    }
}

// #Preview {
//    MainTabView()
// }
