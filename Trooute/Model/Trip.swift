//
//  Trip.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Trip: Codable {
    let v: Int?
    let id: String
    var departureDate: String
    var driver: Driver?
    var passengers: [Passenger]?
    var fromAddress: String
    var whereToAddress: String
    var pricePerPerson: Double?
    var luggageRestrictions: [LuggageRestrictions]?
    var roundTrip: Bool? = false
    var smokingPreference: Bool? = false
    var languagePreference: String? = "Not provided"
    var note: String? = "Not provided"
    var availableSeats: Double?
    var status: String? = "Scheduled"
    var refunded: Bool?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case departureDate
        case driver
        case passengers
        case fromAddress = "from_address"
        case whereToAddress = "whereTo_address"
        case languagePreference
        case note
        case pricePerPerson
        case smokingPreference
        case status
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
