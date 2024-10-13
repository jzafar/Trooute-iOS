//
//  SigninResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

struct SigninResponse: BaseResponse, Codable {
    let success: Bool
    let token: String?
    let data: User?
    let message: String
}
