//
//  TripsData.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct TripsData: BaseTrip, Codable, Identifiable {
    var v: Int?
    var id: String
    var availableSeats: Int?
    var departureDate: String?
    var fromAddress: String?
    var whereToAddress: String?
    var pricePerPerson: Double?
    var status: TripStatus?
    var isAddedInWishList: Bool? = false
    var driver: Driver?
    var fromLocation: Location?
    var languagePreference: String?
    var note: String?
    var passengers: [Passenger]?
    var smokingPreference: Bool? = false
    var petPreference: Bool? = false
    var totalAmount: Double?
    var totalSeats: Int?
    var whereToLocation: Location?
    var bookings: [Booking]?
    var trip: Trip?
    var luggageRestrictions: [LuggageRestrictions?]?
    var roundTrip: Bool? = false
    var isDriverForReviews: Bool? = false // specially added for reviews
    var paymentTypes: [PaymentType]?
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
        case paymentTypes
    }
}
