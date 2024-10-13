//
//  OTPVerificationRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

struct OTPVerificationRequest {
    let OTP: String
    var parameters: [String: Any] {
        return [
            "OTP": OTP
        ]
    }
}
