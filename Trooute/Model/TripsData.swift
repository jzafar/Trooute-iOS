//
//  TripsData.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct TripsData: Codable, Identifiable {
    let v: Int? // This replaces __v in a Swift-friendly way
    let id: String
    var isAddedInWishList: Bool
    let availableSeats: Int
    let departureDate: String
    let driver: Driver?
    let fromAddress: String
    let fromLocation: Location?
    let languagePreference: String?
    let note: String?
    let passengers: [Passenger]?
    let pricePerPerson: Double
    var smokingPreference: Bool = false
    var petPreference: Bool = false
    let status: String
    let totalAmount: Double?
    let totalSeats: Int?
    let whereToAddress: String
    let whereToLocation: Location?
    let bookings: [Booking]?
    let trip: Trip?
    let luggageRestrictions: [LuggageRestrictions?]
    var roundTrip: Bool = false

    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case isAddedInWishList
        case availableSeats
        case departureDate
        case driver
        case fromAddress = "from_address"
        case fromLocation = "from_location"
        case languagePreference
        case note
        case passengers
        case pricePerPerson
        case smokingPreference
        case petPreference
        case status
        case totalAmount
        case totalSeats
        case whereToAddress = "whereTo_address"
        case whereToLocation = "whereTo_location"
        case bookings
        case trip
        case luggageRestrictions
        case roundTrip
    }
}
