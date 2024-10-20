//
//  UpdateCarInfoResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

struct UpdateCarInfoResponse: Codable {
    let data: CarDetails?
    let message: String
    let success: Bool
}
