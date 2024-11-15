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
            
            viewModel.loadData()
        }
        .navigationTitle("Update Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $viewModel.updatePassword) {
            UpdatePasswordView()
        }
    }

    @ViewBuilder
    func fullName() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: String(localized:"Full name"))
            TextField("E.g. John Smith", text: $viewModel.fullName)
                .textFieldStyle(AppTextFieldStyle())
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func emaiView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: String(localized:"Email address"))
            TextField("E.g. John Smith", text: $viewModel.email)
                .textFieldStyle(AppTextFieldStyle())
                .disabled(true)
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func phoneNumber() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: String(localized:"Phone number"))
            TextField("+49XXXXXXXXX", text: $viewModel.phoneNumber)
                .textFieldStyle(AppTextFieldStyle())
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func signInButton() -> some View {
        PrimaryGreenButton(title: String(localized:"Update")) {
            hideKeyboard()
            viewModel.updateProfile()
        }
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    func scendoryGrayButton() -> some View {
        SecondaryGrayButton(title: String(localized:"Update password")) {
            viewModel.updatePassword = true
        }
        .padding(.horizontal, 30)
    }
}

//#Preview {
//    UpdateProfileView()
//}
