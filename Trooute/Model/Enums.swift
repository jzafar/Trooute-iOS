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

enum PaymentType: String, CaseIterable, Identifiable, Codable {
    case cash
    case paypal
    case stripe

    var id: String { rawValue }

    var localizedDdriverString: String {
        switch self {
        case .cash: return String(localized: "Cash Payments")
        case .paypal: return String(localized: "PayPal Payments")
        case .stripe: return String(localized: "Stripe Payments")
        }
    }
    
    var localizedPassengersString: String {
        switch self {
            case .cash: return String(localized: "Pay with Cash")
            case .paypal: return String(localized: "Pay with PayPal (Paypal fee may apply)")
            case .stripe: return String(localized: "Card Payment")
        }
    }
    
    var icon: String {
        switch self {
            case .cash: return "banknote"
            case .paypal: return "p.circle"
            case .stripe: return "creditcard"
        }
    }
}
