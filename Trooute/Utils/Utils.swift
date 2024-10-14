//
//  Utils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//
import SwiftUI

struct Utils {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9._%+-]+)@(?:[a-zA-Z0-9.-]+)\\.[a-zA-Z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    static func convertImageToData(_ image: Image?) -> Data? {
        guard let uiImage = image?.asUIImage() else { return nil }
        return uiImage.jpegData(compressionQuality: 0.7)
    }

    static func checkStatus(isDriverApproved: Bool, status: BookingStatus?) -> (Image, String) {
        var image: Image
        var string: String
        switch status {
        case .waiting:
            image = Image("ic_status_waiting")
            string = isDriverApproved ? "Waiting for approval" : "Waiting"
        case .cancled:
            image = Image("ic_status_cancelled")
            string = "Canceled"
        case .approved:
            image = Image("ic_approved_check")
            if isDriverApproved {
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

    static func downloadImage(url: String) async throws -> Image? {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        if let iamgeData = UIImage(data: data) {
            return Image(uiImage: iamgeData)
        }
        return nil
    }
    
    static func matchPassword(_ password: String, _ confirmPassword: String) -> Bool {
        return password != confirmPassword
    }
    
}
