//
//  CarDetails.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct CarDetails: Codable {
    let color: String?
    let driverLicense: String?
    let make: String?
    let model: String?
    let photo: String?
    let registrationNumber: String?
    let reviews: [String]?
    let reviewsStats: ReviewsStats?
    let year: Int?

    enum CodingKeys: String, CodingKey {
        case color
        case driverLicense
        case make
        case model
        case photo
        case registrationNumber
        case reviews
        case reviewsStats
        case year
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        color = try? values.decodeIfPresent(String.self, forKey: .color)
        driverLicense = try? values.decodeIfPresent(String.self, forKey: .driverLicense)
        make = try? values.decodeIfPresent(String.self, forKey: .make)
        model = try? values.decodeIfPresent(String.self, forKey: .model)
        photo = try? values.decodeIfPresent(String.self, forKey: .photo)
        registrationNumber = try? values.decodeIfPresent(String.self, forKey: .registrationNumber)
        reviews = try? values.decodeIfPresent([String].self, forKey: .reviews)
        reviewsStats = try? values.decodeIfPresent(ReviewsStats.self, forKey: .reviewsStats)
        year = try? values.decodeIfPresent(Int.self, forKey: .year)
       
    }
}

extension CarDetails: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(CarDetails.self, from: data)
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
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(photo, forKey: .photo)
        try container.encodeIfPresent(driverLicense, forKey: .driverLicense)
        try container.encodeIfPresent(make, forKey: .make)
        try container.encodeIfPresent(reviewsStats, forKey: .reviewsStats)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(registrationNumber, forKey: .registrationNumber)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(reviews, forKey: .reviews)
        
    }
}
