//
//  WishList.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//

struct TripInfo: Codable, Identifiable {
    var v: Int?
    let id: String
    var availableSeats: Double?
    var departureDate: String?
    var from_address: String?
    var passengers: [Passenger]?
    var pricePerPerson: Double?
    var whereTo_address: String?
    var isAddedInWishList: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case availableSeats, departureDate, from_address, whereTo_address, passengers, pricePerPerson, isAddedInWishList
    }
}
