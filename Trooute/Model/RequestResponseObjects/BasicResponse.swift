//
//  BasicResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//
import Foundation
struct BasicResponse: Codable {
    let success: Bool
    let message: String
    let url: String?
}
