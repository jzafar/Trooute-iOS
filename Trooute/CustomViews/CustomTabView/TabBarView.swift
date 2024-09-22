//
//  CumstomTabView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import SwiftUI

enum Tab: String, Hashable, CaseIterable {
    case home, inbox, bookings, settings
    var index: Int {
            switch self {
            case .home:
                return 0
            case .inbox:
                return 1
            case .bookings:
                return 2
            case .settings:
                return 3
            }
        }

        var label: String {
            rawValue.capitalized
        }
}
class Tabbar: ObservableObject {
    @Published var hide: Bool = false
    static let shared = Tabbar()
}
struct TabBarView: View {
    @Binding var selection: Tab
    @StateObject private var tabbar = Tabbar.shared
    let onTabSelection: (Tab) -> Void
    var body: some View {
        if tabbar.hide {
            EmptyView()
        } else {
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tabBarItem(for: tab)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selection = tab
                            onTabSelection(tab)
                        }
                }
            }.background(.title)
        }
        
    }

    @ViewBuilder
    private func tabBarItem(for tab: Tab) -> some View {
        switch tab {
        case .home:
            homeView()
        case .inbox:
            inboxView()
        case .bookings:
            bookingsView()
        case .settings:
            settingsView()
        }
    }
    
    @ViewBuilder
    func homeView() -> some View {
        VStack {
            Image(systemName: selection == .home ? "house.fill" : "house")
                .resizable()
                .font(.largeTitle)
                .frame(width: 30, height: 30)
                .padding(.top, 15)
                .foregroundStyle(Color.white)
        }
    }
    
    @ViewBuilder
    func inboxView() -> some View {
        Image(systemName: selection == .inbox ? "bubble.left.fill" : "bubble.left")
            .resizable()
            .font(.largeTitle)
            .frame(width: 30, height: 30)
            .padding(.top, 15)
            .foregroundStyle(Color.white)
    }
    
    @ViewBuilder
    func bookingsView() -> some View {
        Image(systemName: selection == .bookings ? "calendar.circle.fill" : "calendar.circle")
            .resizable()
            .font(.largeTitle)
            .frame(width: 30, height: 30)
            .padding(.top, 15)
            .foregroundStyle(Color.white)
    }
    @ViewBuilder
    func settingsView() -> some View {
        Image(systemName: selection == .settings ? "gearshape.fill" : "gearshape")
            .resizable()
            .font(.largeTitle)
            .frame(width: 30, height: 30)
            .padding(.top, 15)
            .foregroundStyle(Color.white)
    }
    
}
