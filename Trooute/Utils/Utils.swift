//
//  Utils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//
import SwiftUI

struct Utils {
    static func checkStatus(isDriverApproved: Bool, status: BookingStatus?) -> (Image, String) {
        var image: Image
        var string: String
        switch (status) {
        case .waiting:
            image = Image("ic_status_waiting")
            string = isDriverApproved ? "Waiting for approval" : "Waiting"
        case .cancled:
            image = Image("ic_status_cancelled")
            string = "Canceled"
        case .approved:
            image = Image("ic_approved_check")
            if (isDriverApproved) {
                string = "Waiting for payment"
            } else {
                string = "Approved"
            }
        case .confirmed:
            image = Image("ic_confirm_check")
            string = "Confirmed"
        case .completed:
            image = Image("ic_confirm_check")
            string = "Completed"
        case .none:
            image = Image("ic_status_cancelled")
            string = "Unknown"
        }
        return (image, string)
    }
}

