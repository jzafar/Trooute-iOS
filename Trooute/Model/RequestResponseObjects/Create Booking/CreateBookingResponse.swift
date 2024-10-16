//
//  CreateBookingResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-16.
//
import Foundation
struct CreateBookingResponse: Codable {
    let url: String?
    let success: Bool
    let message: String
}
