//
//  ReviewsGiven.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct ReviewsGiven: Codable {
    let v: Int?
    let id: String
    var comment: String?
    var rating: Float?
    let target: String?
    let targetType: String?
    let trip: String?
    let user: String?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case comment
        case rating
        case target
        case targetType
        case trip
        case user
    }
}
