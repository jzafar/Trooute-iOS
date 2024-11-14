//
//  TripsData.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct TripsData: BaseTrip, Codable, Identifiable {
    let v: Int?
    var id: String
    let availableSeats: Int?
    let departureDate: String?
    let fromAddress: String?
    let whereToAddress: String?
    var pricePerPerson: Double?
    var status: TripStatus?
    var isAddedInWishList: Bool? = false
    let driver: Driver?
    let fromLocation: Location?
    let languagePreference: String?
    let note: String?
    var passengers: [Passenger]?
    var smokingPreference: Bool? = false
    var petPreference: Bool? = false
    let totalAmount: Double?
    let totalSeats: Int?
    let whereToLocation: Location?
    var bookings: [Booking]?
    let trip: Trip?
    let luggageRestrictions: [LuggageRestrictions?]?
    var roundTrip: Bool? = false
    var isDriverForReviews: Bool? = false // specially added for reviews
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
