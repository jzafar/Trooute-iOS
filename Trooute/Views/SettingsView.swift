//
//  SettingsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    var body: some View {
        List {
            // Section 1: Driver's Profile
            Section {
                UserInfoCardView(viewModel: UserInfoCardViewModel(user: viewModel.user))
            }

            if (viewModel.isDriverModeOn) {
                if let carDetails = viewModel.carDetails {
                    Section {
                        CarInfoView(viewModel: CarInfoViewModel(carDetails: carDetails))
                    }
                }
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
        .onAppear {
            
        }
        .listStyle(InsetGroupedListStyle())
    }

    @ViewBuilder
    func driverModeView() -> some View {
        Toggle(isOn: $viewModel.isDriverModeOn) {
            HStack {
                Image("ic_become_driver")
                    .resizable()
                    .frame(width: 25, height: 25)

                ListRowText(text: "Driver Mode")
            }
        }.onChange(of: viewModel.isDriverModeOn) { newValue in
            viewModel.toggleDriverMode(newValue) 
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
        NavigationLink(destination: CreateTripView(), label: {
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
            Toggle(isOn: $viewModel.isNotificationOn) {
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
        NavigationLink(destination: FAQView(), label: {
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
