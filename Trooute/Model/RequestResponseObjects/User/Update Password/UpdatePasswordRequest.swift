//
//  UpdatePasswordRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

import Foundation
struct UpdatePasswordRequest {
    let password: String
    let passwordConfirm: String
    let passwordCurrent: String
    
    var parameters: [String: String] {
        return [
            "password": password,
            "passwordConfirm": passwordConfirm,
            "passwordCurrent": passwordCurrent
        ]
    }
}
