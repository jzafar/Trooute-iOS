//
//  Driver.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//
import Foundation

struct Driver: Codable {
    let id: String
    let carDetails: CarDetails?
    let driverMode: Bool?
    let email: String?
    let isApprovedDriver: Bool?
    let name: String
    let photo: String?
    var gender: String? = "male"
    let reviewsStats: ReviewsStats?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case carDetails
        case driverMode
        case email
        case isApprovedDriver
        case name
        case photo
        case reviewsStats
        case gender
    }
}
