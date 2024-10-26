//
//  Review.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

struct Review: Codable, Identifiable, Hashable {
    var v: Int? = 0
    var id: String
    var comment: String? =  "No comment"
    var rating: Double? =  0.0
    var target: String? =  "No target"
    var targetType: String? = "No target type"
    var trip: String? = "No trip"
    var user: String? = "No user"
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case comment, rating, target, targetType, trip, user
    }
}
