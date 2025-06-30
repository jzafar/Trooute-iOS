//
//  User.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//

import Foundation

public struct User: Codable, UserProfile, Identifiable, Hashable {
    public var id: String
    var name: String
    var photo: String?
    var gender: String?
    var rating: String?
    var totlaReview: String?
    let phoneNumber: String?
    let reviewsStats: ReviewsStats?
    var carDetails: CarDetails?
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
    let payPalEmail: String?
    var wishlist: [String]?
    enum CodingKeys: String, CodingKey {
        case carDetails
        case id = "_id"
        case name, email, role, photo, driverMode, isApprovedDriver, phoneNumber, isEmailVerified, status, createdAt, updatedAt, rating, payPalEmail, wishlist
        case v = "__v"
        case emailverifyOTP, passwordChangedAt, stripeConnectedAccountId, stripeToken, gender, reviewsStats, totlaReview
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        photo = try? values.decodeIfPresent(String.self, forKey: .photo)
        gender = try? values.decodeIfPresent(String.self, forKey: .gender)
        rating = try? values.decodeIfPresent(String.self, forKey: .rating)
        totlaReview = try? values.decodeIfPresent(String.self, forKey: .totlaReview)
        phoneNumber  = try? values.decodeIfPresent(String.self, forKey: .phoneNumber)
        reviewsStats = try? values.decodeIfPresent(ReviewsStats.self, forKey: .reviewsStats)
        carDetails = try? values.decodeIfPresent(CarDetails.self, forKey: .carDetails) 
        role = try? values.decodeIfPresent(String.self, forKey: .role)
        driverMode = try values.decodeIfPresent(Bool.self, forKey: .driverMode) ?? false
        isApprovedDriver = try? values.decodeIfPresent(String.self, forKey: .isApprovedDriver)
        isEmailVerified = try? values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try? values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try? values.decodeIfPresent(Int.self, forKey: .v)
        emailverifyOTP = try? values.decodeIfPresent(String.self, forKey: .emailverifyOTP)
        passwordChangedAt = try? values.decodeIfPresent(String.self, forKey: .passwordChangedAt)
        stripeConnectedAccountId = try? values.decodeIfPresent(String.self, forKey: .stripeConnectedAccountId)
        stripeToken = try? values.decodeIfPresent(String.self, forKey: .stripeToken)
        payPalEmail = try? values.decodeIfPresent(String.self, forKey: .payPalEmail)
        wishlist = try? values.decodeIfPresent([String].self, forKey: .wishlist)
    }
}

 extension User: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(User.self, from: data)
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
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try? container.encodeIfPresent(photo, forKey: .photo)
        try? container.encodeIfPresent(gender, forKey: .gender)
        try? container.encodeIfPresent(rating, forKey: .rating)
        try? container.encodeIfPresent(totlaReview, forKey: .totlaReview)
        try? container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try? container.encodeIfPresent(reviewsStats, forKey: .reviewsStats)
        try? container.encodeIfPresent(carDetails, forKey: .carDetails)
        try? container.encodeIfPresent(email, forKey: .email)
        try? container.encodeIfPresent(role, forKey: .role)
        try? container.encodeIfPresent(driverMode, forKey: .driverMode)
        try? container.encodeIfPresent(isApprovedDriver, forKey: .isApprovedDriver)
        try? container.encodeIfPresent(isEmailVerified, forKey: .isEmailVerified)
        try? container.encodeIfPresent(status, forKey: .status)
        try? container.encodeIfPresent(createdAt, forKey: .createdAt)
        try? container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try? container.encodeIfPresent(v, forKey: .v)
        try? container.encodeIfPresent(emailverifyOTP, forKey: .emailverifyOTP)
        try? container.encodeIfPresent(passwordChangedAt, forKey: .passwordChangedAt)
        try? container.encodeIfPresent(stripeConnectedAccountId, forKey: .stripeConnectedAccountId)
        try? container.encodeIfPresent(stripeToken, forKey: .stripeToken)
        try? container.encodeIfPresent(payPalEmail, forKey: .payPalEmail)
    }
 }
