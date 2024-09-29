//
//  Utils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//
import SwiftUI

struct Utils {
    static func checkStatus(isDriverApproved: Bool, status: String) -> (Image, String) {
        var image: Image
        var string: String
        if (status.lowercased() == "waiting") {
            image = Image("ic_status_waiting")
            string = "Waiting"
        } else if (status.lowercased() == "cancled") {
            image = Image("ic_status_cancelled")
            string = "Canceled"
        } else if (status.lowercased() == "approved") {
            image = Image("ic_approved_check")
            if (isDriverApproved) {
                string = "Waiting for payment"
            } else {
                string = "Approved"
            }
        } else if (status.lowercased() == "confirmed") {
            image = Image("ic_confirm_check")
            string = "Confirmed"
        } else if (status.lowercased() == "completed") { // completed
            image = Image("ic_confirm_check")
            string = "Completed"
        } else {
            image = Image("ic_status_cancelled")
            string = "Unknown"
        }
        return (image, string)
    }
}
