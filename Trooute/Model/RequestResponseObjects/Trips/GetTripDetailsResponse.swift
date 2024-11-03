//
//  GetTripDetailsResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation

struct GetTripDetailsResponse: Codable {
    let data: TripsData?
    let message: String
    let success: Bool
}
