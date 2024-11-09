//
//  Enums.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

enum TripStatus: String, Codable {
    case SCHEDULED = "Scheduled"
    case IN_PROGRESS = "In Progress"
    case COMPLETED = "Completed"
    case CANCELED = "Canceled"
    case PickupStarted
    init(from rawValue: String) {
        self = TripStatus(rawValue: rawValue) ?? .SCHEDULED
    }
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
    case isNotificationEnabled = "NOTIFICTIONENABLE"
    var key: String {
        return rawValue
    }
}

enum PickUpPassengersStatus: String, Codable {
    // DriverSide Statues
    case NotStarted
    case PickupStarted
    case PassengerNotified
    case PassengerPickedup
    case PassengerNotShowedup

    // PassengersSide Statues
    case NotSetYet
    case DriverPickedup
    case DriverNotShowedup
    
    init(from rawValue: String) {
        self = PickUpPassengersStatus(rawValue: rawValue) ?? .NotSetYet
    }
}
