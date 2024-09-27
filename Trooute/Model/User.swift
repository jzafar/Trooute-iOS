//
//  User.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String?
    let phoneNumber: String?
    let photo: String?
    let reviewsStats: ReviewsStats?
    let gender: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case phoneNumber
        case photo
        case reviewsStats
        case gender
    }
}
