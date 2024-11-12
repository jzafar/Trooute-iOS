//
//  UpdateProfileView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Combine
import SwiftUI

struct UpdateProfileView: View {
    @StateObject var viewModel = UpdateProfileViewModel()
    @FocusState var keyIsFocused: Bool
    var body: some View {
        VStack {
            RoundProfilePictureView(image: $viewModel.useImage, width: 100)
                .padding(30)
            emaiView()
            fullName()
            phoneNumber()
            signInButton()
                .padding(.top, 50)
            scendoryGrayButton()
            Spacer()
        }.onAppear {
            Tabbar.shared.hide = true
            viewModel.loadData()
        }
        .navigationTitle("Update Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
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
    func emaiView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Email")
            TextField("E.g. John Smith", text: $viewModel.email)
                .textFieldStyle(AppTextFieldStyle())
                .disabled(true)
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func phoneNumber() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Phone Number")
            TextField("+46XXXXXXXXX", text: $viewModel.phoneNumber)
                .textFieldStyle(AppTextFieldStyle())
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func signInButton() -> some View {
        PrimaryGreenButton(title: "Update") {
            hideKeyboard()
            viewModel.updateProfile()
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

//#Preview {
//    UpdateProfileView()
//}
