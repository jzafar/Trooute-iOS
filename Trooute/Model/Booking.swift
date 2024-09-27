//
//  Booking.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct Booking: Codable {
    let v: Int? // This replaces __v in a Swift-friendly way
    let id: String
    var amount: Double = 0.0
    var note: String = ""
    var driverId: String = ""
    var numberOfSeats: Int64 = 0
    var pricePerPerson: Double = 0.0
    var pickupLocation: PickupLocation?
    var reviewsGivenToCar: ReviewsGiven?
    var reviewsGivenToDriver: ReviewsGiven?
    var reviewsGivenToUser: ReviewsGiven?
    var reviewsGivenToUsersByUser: [ReviewsGiven] = []
    var status: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var trip: String = ""
    var tripData: Trip?
    var user: User?
    var pickupStatus: PickupStatus?

    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
    }

    // Codable already handles encoding and decoding automatically
}

struct PickupLocation: Codable {
    var address: String?
    var location: Location?
}

struct PickupStatus: Codable {
    let v: Int
    let id: String
    var driverStatus: String?
    var passengerStatus: String?
    var booking: String?
    var trip: String?

    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case driverStatus
        case passengerStatus
        case booking
        case trip
    }
}
