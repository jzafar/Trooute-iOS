//
//  User.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import Foundation

struct User: UserProfile, Codable, Identifiable {
    var id: String
    var name: String
    var photo: String?
    var gender: String?
    var rating: String?
    var totlaReview: String?
    let phoneNumber: String?
    let reviewsStats: ReviewsStats?
    let carDetails: CarDetails?
    let email: String?
    let role: String?
    var driverMode: Bool?
    let isApprovedDriver: String?
    let isEmailVerified: Bool?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    let emailverifyOTP: String?
    let passwordChangedAt: String?
    let stripeConnectedAccountId: String?
    let stripeToken: String?
    
    enum CodingKeys: String, CodingKey {
            case carDetails
            case id = "_id"
            case name, email, role, photo, driverMode, isApprovedDriver, phoneNumber, isEmailVerified, status, createdAt, updatedAt
            case v = "__v"
            case emailverifyOTP, passwordChangedAt, stripeConnectedAccountId, stripeToken, gender, reviewsStats
        }
}
