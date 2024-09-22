//
//  CountryCode.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import Foundation

struct CountryCode: Codable, Identifiable  {
    let id: String
        let name: String
        let flag: String
        let code: String
        let dial_code: String
        let pattern: String
        let limit: Int
        
        static let allCountry: [CountryCode] = Bundle.main.decode("CountryNumbers.json")
        static let example = allCountry[0]
}
