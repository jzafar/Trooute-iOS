//
//  SettingsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var userModel: UserUtils = UserUtils.shared
    @StateObject var viewModel = SettingsViewModel()
    @Environment(\.openURL) var openURL
    var body: some View {
        List {
            if let user = userModel.user {
                ZStack {
                    NavigationLink(destination: UpdateProfileView()) {
                        EmptyView()
                    }.opacity(0)
                    Section {
                        UserInfoCardView(viewModel: UserInfoCardViewModel(user: user))
                    }

                }.listRowBackground(Color.white)
            }

            if userModel.driverStatus == .approved {
                if let carDetails = userModel.user?.carDetails {
                    Section {
                        CarInfoView(viewModel: CarInfoViewModel(carDetails: carDetails, isEditable: true)) { editCar in
                            viewModel.editCarInfo = editCar
                        }
                    }.listRowBackground(Color.white)
                }
            }

            Section {
                driverModeView()
            }

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
            viewModel.onAppear()
        }.onChange(of: viewModel.isNotificationOn) { _ in
            viewModel.onChangeOfNotification()
        }
        .listStyle(InsetGroupedListStyle())
        .fullScreenCover(isPresented: $viewModel.editCarInfo, onDismiss: {
            viewModel.getMe()
        }, content: {
            BecomeDriverView(viewModel: BecomeDriverViewModel(carDetails: userModel.user?.carDetails))
        })
    }

    @ViewBuilder
    func driverModeView() -> some View {
        if userModel.driverStatus == .approved {
            Toggle(isOn: $viewModel.isDriverModeOn) {
                HStack {
                    Image("ic_become_driver")
                        .resizable()
                        .frame(width: 25, height: 25)
                    ListRowText(text: "Driver Mode")
                }
            }.onChange(of: viewModel.isDriverModeOn) { _ in
                viewModel.toggleDriverMode(userIntrection: viewModel.isUserInteractionWithSwitch)
            }
        } else {
            HStack {
                Image("ic_become_driver")
                    .resizable()
                    .frame(width: 25, height: 25)
                if userModel.driverStatus == .pending {
                    let str = "Driver Mode (Request Pending)"
                    ListRowText(text: str)
                } else if userModel.driverStatus == .rejected {
                    let str = "Driver Mode (Request Rejected)"
                    ListRowText(text: str)
                } else {
                    ListRowText(text: "Become a Driver")
                }
            }.onTapGesture {
                viewModel.editCarInfo = true
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
        NavigationLink(destination: WishView(), label: {
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
        NavigationLink(destination: TripHistoryView(), label: {
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

            HStack {
                Image("ic_invite_friend")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Invite a friend")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray.opacity(0.6))
            }.onTapGesture {
                viewModel.actionSheet()
            }
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
        
            HStack {
                Image("ic_feedback")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Give us feedback")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray.opacity(0.6))
            }.onTapGesture {
               
            }
        

        HStack {
            Image("ic_repot")
                .resizable()
                .frame(width: 25, height: 25)
            ListRowText(text: "Report a problem")
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray.opacity(0.6))
        }.onTapGesture {
            viewModel.sendEmail()
        }
    }

    @ViewBuilder
    func legalSection() -> some View {
        NavigationLink(destination: WebView(webViewModel: WebViewModel(url: Constants.TERMS_CONDITIONS, adjustFont: true)), label: {
            HStack {
                Image("ic_terms_conditions")
                    .resizable()
                    .frame(width: 25, height: 25)
                ListRowText(text: "Terms & Conditions")
            }
        })
        NavigationLink(destination:  WebView(webViewModel: WebViewModel(url: Constants.TERMS_CONDITIONS, adjustFont: true)), label: {
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
            Spacer()
        }.onTapGesture {
            viewModel.logoutPressed()
        }
    }
}

// #Preview {
//    SettingsView()
// }
