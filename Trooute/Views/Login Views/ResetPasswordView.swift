//
//  ResetPasswordView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel = ResetPasswordViewModel()
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            shieldView()
            // Title
            titleView()
            // Description
            descriptionView()
            Spacer().frame(height: 1)
            // Email Field
            emailView()
            Spacer().frame(height: 1)
            // Send link Button
            sendLinkButton()
            Spacer()
        }
        .background(Color(UIColor.white))
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    func shieldView() -> some View {
        Image(systemName: "checkmark.shield")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .foregroundColor(Color.orange)
    }
    
    @ViewBuilder
    func titleView() -> some View {
        Text("Reset your password")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color("TitleColor"))

    }
    
    @ViewBuilder
    func descriptionView() -> some View {
        Text("We will send a code to your phone to reset your password.")
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
            .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func emailView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TextViewLableText(text: "Email address")

            TextField("Your email address here", text: $viewModel.email)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func sendLinkButton() -> some View {
        PrimaryGreenButton(title: "Send link") {
            
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    ResetPasswordView()
}
