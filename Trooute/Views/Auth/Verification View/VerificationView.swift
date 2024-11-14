//
//  VerificationView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

import SwiftUI

struct VerificationView: View {
    @StateObject var viewModel: VerificationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedFieldIndex: Int?
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                shieldView()
                emailTextView()
                codeView()

                HStack {
                    Text("Expired after \(viewModel.countdown)s")
                        .foregroundColor(.gray)

                    Spacer()

                    Button(action: {
                        viewModel.resendOTP()
                    }) {
                        Text("Resend")
                            .font(.body).bold()
                            .foregroundColor(viewModel.isResendEnabled ? Color("TitleColor") : .gray)
                    }
                    .disabled(!viewModel.isResendEnabled)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)

                PrimaryGreenButton(title: "Confirm") {
                    viewModel.submitBtnPressed()
                }

                Spacer()
            }
            .navigationTitle("Verify")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .onAppear {
                viewModel.startCountdown()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusedFieldIndex = 0
                }
            }.toolbar {
                XMarkButton {
                    dismiss()
                }.padding()
            }.onChange(of: viewModel.verified) { newValue in
                if newValue == true {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    func shieldView() -> some View {
        Image(systemName: "shield")
            .resizable()
            .frame(width: 50, height: 60)
            .foregroundColor(.orange)
    }

    @ViewBuilder
    func emailTextView() -> some View {
        Text("Please enter the verification code sent to your \(viewModel.email) Email address")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .padding(.horizontal)
    }

    @ViewBuilder
    func codeView() -> some View {
        HStack(spacing: 10) {
            ForEach(0 ..< 4, id: \.self) { index in
                VerificationTextField(
                    text: $viewModel.code[index],
                    nextFocusAction: {
                        if index < 3 {
                            focusedFieldIndex = index + 1
                        } else {
                            focusedFieldIndex = nil
                        }
                    }
                )
                .focused($focusedFieldIndex, equals: index)
            }
        }
        .padding(.top)
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(viewModel: VerificationViewModel(email: "jahangir141@yahoo.com"))
    }
}

struct VerificationTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var nextFocusAction: (() -> Void)?

    var body: some View {
        TextField("", text: $text)
            .frame(width: 50, height: 50)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .focused($isFocused)
            .onChange(of: text) { newValue in
                if newValue.count == 1 {
                    nextFocusAction?()
                }
                text = String(text.prefix(1))
            }
            .font(.title)
    }
}
