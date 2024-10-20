//
//  SignupResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

struct SignupResponse: BaseResponse, Codable {
    let success: Bool
    let data: User?
    let message: String
}
