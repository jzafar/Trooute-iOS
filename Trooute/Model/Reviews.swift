//
//  Reviews.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-23.
//
import Foundation
struct Reviews: Codable, Identifiable {
    let v: Int?
    let id: String
    let user: User?
    let targetType: String?
    let target: User?
    let comment: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case user, targetType, target, comment, rating
    }
}
