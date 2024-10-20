//
//  UpdateProfileRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//
import Foundation
struct UpdateProfileRequest {
    let name: String
    let phoneNumber: String
    let photo: Data?
    var parameters: [String: Any] {
        if let image = photo {
            return [
                "name": name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                "phoneNumber": phoneNumber.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                "photo": image,
            ]
        }
        return [
            "name": name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
            "phoneNumber": phoneNumber.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
        ]
    }
}
