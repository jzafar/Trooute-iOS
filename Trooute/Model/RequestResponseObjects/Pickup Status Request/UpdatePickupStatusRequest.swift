//
//  UpdatePickupStatusRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//
import Foundation

struct UpdatePickupStatusRequest: Codable {
    let tripId: String
    let bookingId: String
    let pickupStatus: String
    let pickupId: String
    
}
