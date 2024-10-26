//
//  LuggageRestrictions.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

enum LuggageType: String, Codable, Hashable {
    case handCarry = "HandCarry"
    case suitCase = "SuitCase"
}

struct LuggageRestrictions: Codable, Hashable {
    var type: LuggageType = .handCarry
    let weight: Int?
}
