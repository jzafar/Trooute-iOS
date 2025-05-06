//
//  UpdatePaypalRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-27.
//

import Foundation
struct UpdatePaypalRequest {
    let payPalEmail: String
    var parameters: [String: String] {
        return [
            "payPalEmail": payPalEmail
        ]
    }
}
