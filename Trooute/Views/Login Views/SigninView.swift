//
//  Signin.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import SwiftUI

struct SigninView: View {
    @EnvironmentObject var viewModel: SigninViewModel
    var body: some View {
        VStack(spacing: 20) {
            signInText()
            Spacer().frame(height: 30)
            emailView()
            passwordView()
            // Forgot Password
            forgetButtonView()
            Spacer().frame(height: 20)
            // Sign in Button
            signInButton()
            // Sign up
            signupText()
            
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $viewModel.showForgetPassword) {
            ResetPasswordView()
        }.fullScreenCover(isPresented: $viewModel.showSignupView) {
            SignUpView()
        }.fullScreenCover(isPresented: $viewModel.showMainView) {
            MainTabView()
        }
    }
    
    
    @ViewBuilder
    func signInText() -> some View {
        Text("Sign in")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 20)
            .foregroundColor(Color("TitleColor"))
    }
    
    @ViewBuilder
    func emailView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TextViewLableText(text: "Email address")

            TextField("Your email address here", text: $viewModel.email)
                .textFieldStyle(AppTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func passwordView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TextViewLableText(text: "Password")

            HStack {
                if viewModel.isPasswordVisible {
                    TextField("Your password here", text: $viewModel.password)
                        .textFieldStyle(AppTextFieldStyle())
                } else {
                    SecureField("Your password here", text: $viewModel.password)
                        .textFieldStyle(AppTextFieldStyle())
                }

                Button(action: {
                    viewModel.isPasswordVisible.toggle()
                }) {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(Color.gray)
                }
                Spacer()
            }.background(Color(UIColor.systemGray6))
                .cornerRadius(8)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func forgetButtonView() -> some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.showForgetPassword.toggle()
            }) {
                Text("Forgot password?")
                    .foregroundColor(Color("TitleColor"))
                    .font(.subheadline)
            }
        }
        .padding(.trailing, 30)
        .padding(.top, 5)
    }
    
    @ViewBuilder
    func signInButton() -> some View {
        PrimaryGreenButton(title: "Sign in") {
            viewModel.loginButtonPress()
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func signupText() -> some View {
        HStack {
            Text("Don't have an account?")
                .foregroundColor(.gray)

            Button(action: {
                viewModel.showSignupView = true
            }) {
                Text("Sign up")
                    .foregroundColor(Color.primaryGreen)
                    .fontWeight(.bold)
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    SigninView()
}
