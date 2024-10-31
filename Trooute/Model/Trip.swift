//
//  Trip.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Trip: Codable, Hashable {
    let v: Int?
    let id: String
    var departureDate: String
    var fromAddress: String
    var whereToAddress: String
    var driver: Driver?
    var passengers: [Passenger]?
    var pricePerPerson: Double?
    var luggageRestrictions: [LuggageRestrictions]?
    var roundTrip: Bool? = false
    var smokingPreference: Bool? = false
    var petPreference: Bool? = false
    var languagePreference: String? = "Not provided"
    var note: String? = "Not provided"
    var availableSeats: Int?
    var status: TripStatus? = .SCHEDULED
    var refunded: Bool?
    var createdAt: String?
    var updatedAt: String?
    var from_location: Location?
    var whereTo_location: Location?
    var totalSeats: Int?
    var isAddedInWishList: Bool? = false
    var totalAmount: Double? = 0.0
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case departureDate, createdAt, updatedAt
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
        case petPreference
        case availableSeats, totalSeats
        case from_location, whereTo_location
        case isAddedInWishList
        case totalAmount
    }
}

struct Location: Codable, Hashable {
    let coordinates: [Double]?
    let type: String?
    
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
