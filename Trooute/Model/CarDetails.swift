//
//  CarDetails.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct CarDetails: Codable {
    let color: String
    let driverLicense: String
    let make: String
    let model: String
    let photo: String
    let registrationNumber: String
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
}
