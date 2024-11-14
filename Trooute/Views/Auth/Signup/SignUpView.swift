//
//  SignUpView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import SwiftUI
import Combine

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    cameraButton()
                        .padding(.top, 20)
                    
                    fullName()
                    emailView()
                    genderView()
                    phoneNumberView()
                    passwordView()
                    confirmPasswordView()
                    tandCView()
                    signUpButtonView()
                    alreadyAccount()
                }.ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationTitle("Sign up")
            .background(.white)
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $viewModel.presentSheet) {
                countryPickerView()
            }
            .presentationDetents([.medium, .large])
            .toolbar {
                XMarkButton {
                    dismiss()
                }.padding()
            }.fullScreenCover(isPresented: $viewModel.showVerificationView) {
                self.dismiss()
            } content: {
                VerificationView(viewModel: VerificationViewModel(email: viewModel.email))
            }

        }
    }

    @ViewBuilder
    func countryPickerView() -> some View {
        NavigationView {
            List(viewModel.filteredResorts) { country in
                HStack {
                    Text(country.flag)
                    Text(country.name)
                        .font(.headline)
                    Spacer()
                    Text(country.dial_code)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    viewModel.countryFlag = country.flag
                    viewModel.countryCode = country.dial_code
                    viewModel.countryPattern = country.pattern
                    viewModel.countryLimit = country.limit
                    viewModel.presentSheet = false
                    viewModel.searchCountry = ""
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchCountry, prompt: "Your country")
        }
        .presentationDetents([.medium, .large])
    }
    
    @ViewBuilder
    func signUpText() -> some View {
        Text("Sign up")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 20)
            .foregroundColor(Color("TitleColor"))
    }

    
    func cameraButton() -> some View {
        RoundProfilePictureView(image: $viewModel.photo, width: 100) 
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
    func emailView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Email address")
            TextField("Your email address here", text: $viewModel.email)
                .textFieldStyle(AppTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func genderView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                TextViewLableText(text: "Gender")
                HStack {
                    RadioButtonField(label: "Male", isSelected: $viewModel.gender, value: "Male")
                    RadioButtonField(label: "Female", isSelected: $viewModel.gender, value: "Female")
                }
            }
            Spacer()
        }.frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func phoneNumberView() -> some View {
        VStack(alignment: .leading) {
            TextViewLableText(text: "Phone number")
            HStack {
                Button {
                    viewModel.presentSheet = true
                } label: {
                    Text("\(viewModel.countryFlag) \(viewModel.countryCode)")
                        .padding(10)
                        .frame(minWidth: 80, minHeight: 55)
                        .background(Color(UIColor.systemGray6))
                        .foregroundColor(.black)
                }.cornerRadius(8)
                
                TextField("Phone number", text: $viewModel.mobPhoneNumber)
                    .textFieldStyle(AppTextFieldStyle())
                    .keyboardType(.phonePad)
                    .frame(minWidth: 80, minHeight: 47)
                    .onReceive(Just(viewModel.mobPhoneNumber)) { number in
//                        viewModel.applyPatternOnNumbers(&viewModel.mobPhoneNumber, pattern: viewModel.countryPattern, replacementCharacter: "#")
                    }
                    
            }
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
                }.buttonStyle(PlainButtonStyle())
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
                }.buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func tandCView() -> some View {
        HStack {
            Toggle("", isOn: $viewModel.agreeToTerms)
                .toggleStyle(CheckboxStyle())
                .tint(Color("PrimaryGreen"))
            Text("Agree to")
                .foregroundColor(.primary)
            Button(action: {
                openURL(URL(string: Constants.TERMS_CONDITIONS)!)
            }) {
                Text("Terms & Conditions")
                    .foregroundColor(.blue)
                    .underline()
            }.buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func signUpButtonView() -> some View {
        PrimaryGreenButton(title: "Sign up") {
            viewModel.signupButtonPressed()
        }.padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func alreadyAccount() -> some View {
        HStack {
            Text("Already have an account?")
                .foregroundColor(.gray)

            Button(action: {
                dismiss()
            }) {
                Text("Sign in")
                    .foregroundColor(Color("PrimaryGreen"))
                    .fontWeight(.bold)
            }.buttonStyle(PlainButtonStyle())
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    SignUpView()
}
