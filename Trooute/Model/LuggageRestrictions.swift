//
//  LuggageRestrictions.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

enum LuggageType: String, Codable {
    case handCarry = "HandCarry"
    case suitCase = "SuitCase"
}

struct LuggageRestrictions: Codable {
    var type: LuggageType = .handCarry
    let weight: Int64?
}
