//
//  SignupRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//
import Foundation
struct SignupRequest {
    let name: String
    let email: String
    let password: String
    let phoneNumber: String
    let gender: String
    let photo: Data?
    var parameters: [String: Any] {
        if let image = photo {
            return [
                "email": email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                "password": password,
                "name": name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                "phoneNumber": phoneNumber.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                "gender": gender,
                "photo": image,
            ]
        }
        return [
            "email": email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
            "password": password,
            "name": name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
            "phoneNumber": phoneNumber.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
            "gender": gender,
        ]
    }
}
