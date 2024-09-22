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
    @FocusState var keyIsFocused: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
//                    signUpText()
                    // Profile picture
                    cameraButton()
                        .padding(.top, 20)
                    
                    // Full Name
                    fullName()
                    
                    // Email
                    emailView()
                    
                    // Gender
                    genderView()
                    
                    // Phone Number
                    phoneNumberView()
                    
                    // Password
                    passwordView()
                    
                    // Confirm Password
                    confirmPasswordView()
                    
                    // Terms and Conditions
                    tandCView()
                    
                    // Sign up Button
                    signUpButtonView()
                    
                    alreadyAccount()
                }
            }
            .navigationTitle("Sign up")
            .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
            .background(.white)
            .ignoresSafeArea(.keyboard)
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
        ProfilePictureView(width: 100, height: 100) {
            
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
                    keyIsFocused = false
                } label: {
                    Text("\(viewModel.countryFlag) \(viewModel.countryCode)")
                        .padding(10)
                        .frame(minWidth: 80, minHeight: 55)
                        .background(Color(UIColor.systemGray6))
                        .foregroundColor(.black)
                }.cornerRadius(8)
                
                TextField("Phone number", text: $viewModel.mobPhoneNumber)
                    .textFieldStyle(AppTextFieldStyle())
                    .focused($keyIsFocused)
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
    func tandCView() -> some View {
        HStack {
            Toggle("", isOn: $viewModel.agreeToTerms)
                .toggleStyle(CheckboxToggleStyle())
                .tint(Color("PrimaryGreen"))
            Text("Agree to")
                .foregroundColor(.primary)
            Button(action: {
                // Action to show terms
            }) {
                Text("Terms & Conditions")
                    .foregroundColor(.blue)
                    .underline()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func signUpButtonView() -> some View {
        PrimaryGreenButton(title: "Sign up") {
            
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
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    SignUpView()
}
