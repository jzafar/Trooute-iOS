//
//  GetReviewsResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-23.
//

struct GetReviewsResponse: Codable {
    let data: [Reviews]?
    let success: Bool
    let message: String
    
    
}
