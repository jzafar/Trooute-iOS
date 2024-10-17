//
//  GetBookingsResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//
import Foundation
struct GetBookingsResponse: Codable {
    let data: [BookingData]?
    let message: String
    let success: Bool
}
