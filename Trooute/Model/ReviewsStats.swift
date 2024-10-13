//
//  ReviewsStats.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct ReviewsStats: Codable {
    let avgRating: Float?
    let ratings: Ratings?
    let totalReviews: Int?

    enum CodingKeys: String, CodingKey {
        case avgRating
        case ratings
        case totalReviews
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avgRating = try values.decodeIfPresent(Float.self, forKey: .avgRating)
        ratings = try? values.decodeIfPresent(Ratings.self, forKey: .ratings)
        totalReviews = try? values.decodeIfPresent(Int.self, forKey: .totalReviews)
    }
}
extension ReviewsStats: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(ReviewsStats.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(avgRating, forKey: .avgRating)
        try container.encodeIfPresent(ratings, forKey: .ratings)
        try container.encodeIfPresent(totalReviews, forKey: .totalReviews)
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        oneStar = try? values.decodeIfPresent(Float.self, forKey: .oneStar)
        twoStars = try? values.decodeIfPresent(Float.self, forKey: .twoStars)
        threeStars = try? values.decodeIfPresent(Float.self, forKey: .threeStars)
        fourStars = try? values.decodeIfPresent(Float.self, forKey: .fourStars)
        fiveStars = try? values.decodeIfPresent(Float.self, forKey: .fiveStars)
       
    }
}

extension Ratings: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Ratings.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(oneStar, forKey: .oneStar)
        try container.encodeIfPresent(twoStars, forKey: .twoStars)
        try container.encodeIfPresent(threeStars, forKey: .threeStars)
        try container.encodeIfPresent(fourStars, forKey: .fourStars)
        try container.encodeIfPresent(fiveStars, forKey: .fiveStars)
    }
}
