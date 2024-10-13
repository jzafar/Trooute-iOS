//
//  UpdateProfileView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Combine
import SwiftUI

struct UpdateProfileView: View {
    @ObservedObject var viewModel = UpdateProfileViewModel()
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @FocusState var keyIsFocused: Bool
    var body: some View {
        VStack {

            RoundProfilePictureView(image: $viewModel.useImage, width: 100)
                .padding(30)

            fullName()

            phoneNumber()

            signInButton()
                .padding(.top, 50)
            scendoryGrayButton()
            Spacer()
        }.onAppear {
            Tabbar.shared.hide = true
            viewModel.fullName = user?.name ?? ""
            viewModel.phoneNumber = user?.phoneNumber ?? ""
            
        }
        .navigationTitle("Update Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.updatePassword) {
            UpdatePasswordView()
        }
    }

    @ViewBuilder
    func fullName() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Full name")
            TextField("E.g. John Smith", text: $viewModel.fullName)
                .textFieldStyle(AppTextFieldStyle())
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func phoneNumber() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Phone Number")
            TextField("+49XXXXXXXXX", text: $viewModel.phoneNumber)
                .textFieldStyle(AppTextFieldStyle())
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func signInButton() -> some View {
        PrimaryGreenButton(title: "Update") {
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func scendoryGrayButton() -> some View {
        SecondaryGrayButton(title: "Update Password") {
            viewModel.updatePassword = true
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    UpdateProfileView()
        .environmentObject(SigninViewModel())
}
