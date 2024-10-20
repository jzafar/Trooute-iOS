//
//  UpdateDeviceIDRequest.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

struct UpdateDeviceIDRequest {
    let deviceId: String
    var parameters: [String: Any] {
        return [
            "deviceType": "ios",
            "deviceId": deviceId,
        ]
    }
}
