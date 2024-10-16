//
//  CreateBookingRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-16.
//
import Foundation
struct CreateBookingRequest: Codable {
    let amount: Double
    let note: String
    let numberOfSeats: Int
    let pickupLocation: BookingPickupLocation
    let trip: String
    var plateFormFee: Double = 1.0
}

struct BookingPickupLocation: Codable {
    var address: String
    var location: [Double]
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
