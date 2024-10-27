//
//  GetWishListResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//

import Foundation
struct GetTripListResponse: Codable {
    let data: [TripInfo]?
    let message: String
    let success: Bool
}
