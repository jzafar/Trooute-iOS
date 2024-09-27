//
//  Passenger.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Passenger: Codable {
    let id: String
    let photo: String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case photo
    }
}
