//
//  SigninRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

struct SigninRequest {
    let email: String
    let password: String

    var parameters: [String: String] {
        return [
            "email": email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
            "password": password,
        ]
    }
}
