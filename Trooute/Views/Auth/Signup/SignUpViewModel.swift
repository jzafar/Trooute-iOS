//
//  SignUpViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//
import Foundation
import SwiftLoader
import SwiftUI
class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var gender = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var agreeToTerms = false
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var presentSheet = false
    @Published var photo: Image? = nil
    @Published var countryCode : String = "+1"
    @Published var countryFlag : String = "🇺🇸"
    @Published var countryPattern : String = "### ### ####"
    @Published var countryLimit : Int = 17
    @Published var mobPhoneNumber = ""
    @Published var searchCountry: String = ""
    @Published var showVerificationView = false
    private let repository = SignupRepository()
    let counrties: [CountryCode] = Bundle.main.decode("CountryNumbers.json")
    var filteredResorts: [CountryCode] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.contains(searchCountry) }
        }
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
    }
    
    
    func signupButtonPressed() {
        if agreeToTerms == false {
            BannerHelper.displayBanner(.info, message: "Please accept terms and conditions")
            return
        } else if email.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            BannerHelper.displayBanner(.error, message: "Email can\'t be blank.")
            return
        } else if password.count == 0 {
            BannerHelper.displayBanner(.error, message: "Password can\'t be blank")
            return
        } else if confirmPassword.count == 0 {
            BannerHelper.displayBanner(.error, message: "Retype your password. It can\'t be blank")
            return
        } else if fullName.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            BannerHelper.displayBanner(.error, message: "Full Name feild can\'t be blank")
            return
        } else if mobPhoneNumber.count == 0 {
            BannerHelper.displayBanner(.error, message: "Phone number is not correct")
            return
        } else if Utils.matchPassword(password, confirmPassword) {
            BannerHelper.displayBanner(.error, message: "Passwords did not matched")
            return
        } else if !Utils.isValidEmail(email) {
            BannerHelper.displayBanner(.error, message: "Email is not valid")
            return
        } else if gender.count == 0 {
            BannerHelper.displayBanner(.error, message: "Please select gender")
            return
        } else if password.count < 8 {
            BannerHelper.displayBanner(.error, message: "Password needs to consist of at least 8 characters")
            return
        } else {
            let signupRequest = SignupRequest(name: fullName, email: email, password: password, phoneNumber: mobPhoneNumber, gender: gender, photo: Utils.convertImageToData(self.photo))
            SwiftLoader.show(title: "Signing up...", animated: true)
            repository.signup(signinRequest: signupRequest) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success {
                        self?.showVerificationView = true
                        BannerHelper.displayBanner(.success, message:  response.data.message)
                    } else {
                        BannerHelper.displayBanner(.error, message:  response.data.message)
                    }
                case .failure(let error):
                    BannerHelper.displayBanner(.error, message:  error.localizedDescription)
                }
            }
        }
    }
}
