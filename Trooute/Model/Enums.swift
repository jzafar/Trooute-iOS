//
//  Enums.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

enum TripStatus: String {
    case SCHEDULED = "Scheduled"
    case IN_PROGRESS = "In Progress"
    case COMPLETED = "Completed"
    case CANCELED = "Canceled"
    case PickupStarted = "PickupStarted"
}

enum DriverStatus: String, Codable {
    case approved, pending, rejected, unknown
    init(from rawValue: String) {
            self = DriverStatus(rawValue: rawValue) ?? .unknown
        }
}

enum UserDefaultsKey: String {
    case user = "USER"
    case token = "TOKEN"
    case driverMode = "DriverMode"
    case stripeToken = "StripeToken"
    case driverState = "DriverState"
    var key: String {
        return rawValue
    }
}
