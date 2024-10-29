//
//  UpdatePasswordView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import SwiftUI

struct UpdatePasswordView: View {
    @ObservedObject var viewModel = UpdatePasswordViewModel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                currentPasswordView()
                passwordView()
                confirmPasswordView()
                updateButton()
                    .padding(.top,30)
                Spacer()
            }
        }.navigationTitle("Update Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
    }
    
    @ViewBuilder
    func currentPasswordView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Current Password")
            HStack {
                if viewModel.showCurrentPassword {
                    TextField("Type your current password here", text: $viewModel.currentPassword)
                } else {
                    SecureField("Type your current password here", text: $viewModel.currentPassword)
                }
                Button(action: {
                    viewModel.showCurrentPassword.toggle()
                }) {
                    Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func passwordView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Password")
            HStack {
                if viewModel.showPassword {
                    TextField("Your password here", text: $viewModel.password)
                } else {
                    SecureField("Your password here", text: $viewModel.password)
                }
                Button(action: {
                    viewModel.showPassword.toggle()
                }) {
                    Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func confirmPasswordView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Retype your password")
            HStack {
                if viewModel.showConfirmPassword {
                    TextField("Retype your password here", text: $viewModel.confirmPassword)
                } else {
                    SecureField("Retype your password here", text: $viewModel.confirmPassword)
                }
                Button(action: {
                    viewModel.showConfirmPassword.toggle()
                }) {
                    Image(systemName: viewModel.showConfirmPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func updateButton()-> some View {
        PrimaryGreenButton(title: "Update") {
            viewModel.updatePasswordPressed()
        }
        .padding(.horizontal, 30)
    }
}

//#Preview {
//    UpdatePasswordView()
//}
