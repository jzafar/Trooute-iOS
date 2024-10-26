//
//  CreateTripRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-25.
//
import Foundation
struct CreateTripRequest: Codable {
    let departureDate: String
    let from_address: String
    let from_location: [Double]
    let pricePerPerson: Double
    let smokingPreference: Bool
    let petPreference: Bool
    var roundTrip: Bool = false
    var status: String = ""
    let totalSeats: Int
    let whereTo_address: String
    let whereTo_location: [Double]
    let languagePreference: String?
    let luggageRestrictions: [LuggageRestrictions]
    let note: String?
    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        if let languagePreference = languagePreference {
            params["languagePreference"] = "\(languagePreference)"
        }
        if let note = note {
            params["note"] = "\(note)"
        }
        
        params["luggageRestrictions"] = "\(luggageRestrictions)"
        params["departureDate"] = departureDate
        params["from_address"] = from_address
        params["from_location"] = from_location
        params["pricePerPerson"] = pricePerPerson
        params["smokingPreference"] = smokingPreference
        params["petPreference"] = petPreference
        params["roundTrip"] = roundTrip
        params["status"] = status
        params["totalSeats"] = totalSeats
        params["whereTo_address"] = whereTo_address
        params["whereTo_location"] = whereTo_location
        return params
    }
}
