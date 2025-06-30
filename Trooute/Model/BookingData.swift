//
//  BookingData.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

struct BookingData: Codable, Identifiable {
    var v: Int? = 0
    var id: String
    var amount: Double?
    var note: String?
    var numberOfSeats: Int?
    var pickupLocation: PickupLocation?
    let status: BookingStatus?
    var trip: Trip
    var user: User?
    var driverToUserReview: Review?
    var userToCarReview: Review?
    var userToDriverReview: Review?
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case trip
        case amount
        case note
        case numberOfSeats
        case pickupLocation
        case status
        case user
        case driverToUserReview
        case userToCarReview
        case userToDriverReview
    }
}

enum BookingStatus: String, Codable, Hashable {
    case waiting = "Waiting"
    case canceled = "Canceled"
    case approved = "Approved"
    case confirmed = "Confirmed"
    case completed = "Completed"
    case pendingDriverPayment = "PendingDriverPayment"
}
