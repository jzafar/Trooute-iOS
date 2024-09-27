//
//  ReviewsStats.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct ReviewsStats: Codable {
    let avgRating: Float
    let ratings: Ratings?
    let totalReviews: Int

    enum CodingKeys: String, CodingKey {
        case avgRating
        case ratings
        case totalReviews
    }
}

struct Ratings: Codable {
    let oneStar: Float?
    let twoStars: Float?
    let threeStars: Float?
    let fourStars: Float?
    let fiveStars: Float?

    enum CodingKeys: String, CodingKey {
        case oneStar = "1"
        case twoStars = "2"
        case threeStars = "3"
        case fourStars = "4"
        case fiveStars = "5"
    }
}
