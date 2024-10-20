//
//  GetNearByTripsRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-14.
//

struct GetTripsRequest {
    var fromLatitude: Double?
    var fromLongitude: Double?
    var whereLatitude: Double?
    var whereLongitude: Double?
    var currentDate: String?
    var flexibleDays: Int?
    var toRange: Int?
    var fromRange: Int?
    var departureDate: String?
    var parameters: [String: String] {
        var params: [String: String] = [:]
        
        if let fromLongitude = fromLongitude {
            params["fromCoordinates[0]"] = "\(fromLongitude)"
        }
        if let fromLatitude = fromLatitude {
            params["fromCoordinates[1]"] = "\(fromLatitude)"
        }
        if let whereLatitude = whereLatitude {
            params["whereToCoordinates[0]"] = "\(whereLatitude)"
        }
        if let whereLongitude = whereLongitude {
            params["whereToCoordinates[1]"] = "\(whereLongitude)"
        }
        if let currentDate = currentDate {
            params["currentDate"] = currentDate
        }
        if let departureDate = departureDate {
            params["departureDate"] = departureDate
        }
        if let flexibleDays = flexibleDays {
            params["flexibleDays"] = "\(flexibleDays)"
        }
        if let toRange = toRange {
            params["toRange"] = "\(toRange)"
        }
        if let fromRange = fromRange {
            params["fromRange"] = "\(fromRange)"
        }
        
        return params
    }
}
