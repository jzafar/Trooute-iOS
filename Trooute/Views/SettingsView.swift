//
//  SettingsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct SettingsView: View {
    @State private var isDriverModeOn = true
    @State private var isNotificationOn = true
    var body: some View {
        List {
            // Section 1: Driver's Profile
            Section {
                UserInfoCardView()
            }

            // Section 2: Vehicle Information
            Section {
                CarInfoView()
            }

            // Section 3: Driver Mode Toggle
            Section {
                driverModeView()
            }

            // Section 4: Settings
            Section(header: TextViewLableText(text: "Settings")) {
                settingsSection()
            }.listRowSeparator(.hidden)

            // Section 5: Support
            Section(header: TextViewLableText(text: "Support")) {
                supportSection()
            }.listRowSeparator(.hidden)

            // Section 6: Legal
            Section(header: TextViewLableText(text: "Legal")) {
                legalSection()
            }.listRowSeparator(.hidden)

            // Section 7: Logout
            Section {
                logoutSection()
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    @ViewBuilder
    func driverModeView() -> some View {
        Toggle(isOn: $isDriverModeOn) {
            HStack {
                Image("ic_become_driver")
                    .resizable()
                    .frame(width: 25, height: 25)

                ListRowText(text: "Driver Mode")
            }
        }
    }

    @ViewBuilder
    func settingsSection() -> some View {
        NavigationLink(destination: UpdateProfileView(), label: {
            HStack {
                Image("ic_profile")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Profile")
                    
            }
        })
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_heart")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Bookmark")
            }
        })
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_createtrip")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Create a new trip")
            }
        })
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_triphistory")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Trip History")
            }
        })
        HStack {
            Toggle(isOn: $isNotificationOn) {
                HStack {
                    Image("ic_noti")
                        .resizable()
                        .frame(width: 25, height: 25)
                    ListRowText(text: "Notifications")
                }
            }
        }

        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_invite_friend")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Invite a friend")
            }
        })
    }

    @ViewBuilder
    func supportSection() -> some View {
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_faq")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Frequently asked questions")
            }
        })
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_feedback")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Give us feedback")
            }
        })
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_repot")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Report a problem")
            }
        })
    }

    @ViewBuilder
    func legalSection() -> some View {
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_terms_conditions")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Terms & Conditions")
            }
        })
        NavigationLink(destination: EmptyView(), label: {
            HStack {
                Image("ic_privacy_policy")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Privacy Policy")
            }
        })
    }

    @ViewBuilder
    func logoutSection() -> some View {
        HStack {
            Image("ic_logout")
                .resizable()
                .frame(width: 25, height: 25)
            ListRowText(text: "Logout")
        }
    }
}

#Preview {
    SettingsView()
}
