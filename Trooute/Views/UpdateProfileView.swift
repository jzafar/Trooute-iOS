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
    @FocusState var keyIsFocused: Bool
    var body: some View {
        VStack {
            ProfilePictureView(width: 100, height: 100) {
            }.padding(30)

            fullName()

            phoneNumber()

            signInButton()
                .padding(.top, 50)
            scendoryGrayButton()
            Spacer()
        }.onAppear {
            Tabbar.shared.hide = true
        }
        .navigationTitle("Update Profile")
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
            TextField("+46766966066", text: $viewModel.phoneNumber)
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
        ScendoryGrayButton(title: "Update Password") {
            viewModel.updatePassword = true
        }
//        NavigationLink(destination: UpdatePasswordView()) {
//            Text("Update Password")
//                .padding()
//                .foregroundColor(.gray)
//                .font(.title2)
//                .fontWeight(.bold)
//           }
//        NavigationLink {
//            UpdatePasswordView()
//        } label: {
//            Text("Update Password")
//                .padding()
//                .foregroundColor(.gray)
//                .font(.title2)
//                .fontWeight(.bold)
//                .background(.white)
//        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    UpdateProfileView()
}
