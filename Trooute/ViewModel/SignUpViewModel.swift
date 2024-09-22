//
//  SignUpViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//
import Foundation
class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var gender = ""
    @Published var phoneNumber = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var agreeToTerms = false
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var presentSheet = false
    
    @Published var countryCode : String = "+1"
    @Published var countryFlag : String = "🇺🇸"
    @Published var countryPattern : String = "### ### ####"
    @Published var countryLimit : Int = 17
    @Published var mobPhoneNumber = ""
    @Published var searchCountry: String = ""
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
}
