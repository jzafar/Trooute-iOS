//
//  Passenger.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Passenger: Codable, Identifiable, Hashable {
    let id: String
    var photo: String?
    let gender: String?
    let reviewsStats: ReviewsStats?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case photo, gender, reviewsStats
    }

    static func == (lhs: Passenger, rhs: Passenger) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
