//
//  ResendOTPRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

struct ResendOTPRequest {
    let email: String
    var parameters: [String: Any] {
        return [
            "email": email
        ]
    }
}
