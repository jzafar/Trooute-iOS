//
//  PostReviewRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-04.
//

import Foundation

struct PostReviewRequest: Codable {
    let trip: String
    let targetId: String
    let targetType: TargetType
    var comment: String
    var rating: Double
}
enum TargetType: String, Codable {
    case Driver
    case Car
    case User
}
