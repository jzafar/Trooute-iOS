//
//  Trip.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Trip: Codable {
    let v: Int? // Replaces __v in Swift-friendly way
    let id: String
    let availableSeats: Int?
    let departureDate: String
    let driver: Driver?
    let fromAddress: String
    let fromLocation: Location?
    let languagePreference: String
    let note: String
    let pricePerPerson: Double
    let smokingPreference: Bool
    let petPreference: Bool
    let status: String
    let totalAmount: Double
    let totalSeats: Int
    let whereToAddress: String
    let whereToLocation: Location?
    let luggageRestrictions: [LuggageRestrictions?]
    let roundTrip: Bool

    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case availableSeats
        case departureDate
        case driver
        case fromAddress = "from_address"
        case fromLocation = "from_location"
        case languagePreference
        case note
        case pricePerPerson
        case smokingPreference
        case petPreference
        case status
        case totalAmount
        case totalSeats
        case whereToAddress = "whereTo_address"
        case whereToLocation = "whereTo_location"
        case luggageRestrictions
        case roundTrip
    }
}

struct Location: Codable {
    let coordinates: [Double]?
    let type: String

    enum CodingKeys: String, CodingKey {
        case coordinates
        case type
    }

    // Provide a default value for "type" in case it's not provided
    init(coordinates: [Double]? = nil, type: String? = nil) {
        self.coordinates = coordinates
        self.type = type ?? "No type"
    }
}
