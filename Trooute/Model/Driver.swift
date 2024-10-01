//
//  Driver.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//
import Foundation

struct Driver: UserProfile, Codable {
    var id: String
    var name: String
    var photo: String?
    var gender: String? = "Not provided"
    let carDetails: CarDetails?
    let driverMode: Bool?
    let email: String?
    let isApprovedDriver: String?
    let reviewsStats: ReviewsStats?
    let stripeConnectedAccountId: String?
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
        case stripeConnectedAccountId
    }
}
