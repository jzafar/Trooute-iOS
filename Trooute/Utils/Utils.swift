//
//  Utils.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//
import SwiftUI
import Firebase

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
            string = isDriverApproved ? String(localized:"Waiting for approval") : String(localized:"Waiting")
        case .canceled:
            image = Image("ic_status_cancelled")
            string = String(localized:"Canceled")
        case .approved:
            image = Image("ic_approved_check")
            if isDriverApproved {
                string = String(localized:"Waiting for payment")
            } else {
                string = String(localized:"Approved")
            }
        case .confirmed:
            image = Image("ic_confirm_check")
            string = String(localized:"Confirmed")
        case .completed:
            image = Image("ic_confirm_check")
            string = String(localized:"Completed")
        case .none:
            image = Image("ic_status_cancelled")
            string = String(localized:"Unknown")
        }
        return (image, string)
    }
    
    static func checkPickUpStatus(isDriver: Bool, status: PickUpPassengersStatus?) -> (Image, String, String) {
        var image: Image
        var statusString: String
        var statusDetails: String
        switch status {
            
        case .NotSetYet:
            image = Image("ic_status_waiting")
            statusString = String(localized:"Waiting To Be Picked up")
            statusDetails = String(localized:"When you notify passenger to get ready we'll send a notification to passenger to get ready for pickup")
        case .DriverPickedup:
            image = Image("ic_confirm_check")
            statusString = String(localized:"Picked up")
            statusDetails = String(localized:"Trooute wishes you safe journey.")
        case .DriverNotShowedup:
            image = Image("ic_status_cancelled")
            statusString = String(localized:"Not Showed up")
            statusDetails = isDriver ? String(localized:"The passenger has marked that you didn’t show up. Please pick up the passenger.") : String(localized:"You have marked as driver not showed up. You can contact support from settings page.")
            
        case .PickupStarted:
            image = Image("ic_status_waiting")
            statusString = String(localized:"Pickup started")
            statusDetails = String(localized:"Driver has started to pick up passengers.")
            
        case .PassengerNotified:
            image = Image("ic_status_waiting")
            statusString = String(localized:"Get ready")
            statusDetails = String(localized:"Driver is coming to you to pick you up.")
            
        case .PassengerPickedup:
            image = Image("ic_status_waiting")
            statusString = String(localized:"Picked up")
            statusDetails = String(localized:"Driver marked you as a picked up. if it's correct please mark yourself as picked up.")
            
        case .PassengerNotShowedup:
            image = Image("ic_status_waiting")
            statusString = String(localized:"Not Showed up")
            statusDetails = String(localized:"Driver marked you as not showed up. If it's not true you can contact support from settings page.")
            
            
        default:
            image = Image("ic_status_cancelled")
            statusString = String(localized:"Unknown")
            statusDetails = String(localized:"Unknown")
        }
        
        return (image, statusString, statusDetails)
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
    
    static func getRootViewController() -> UIViewController? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }

        guard let firstWindow = firstScene.windows.first else {
            return nil
        }

        return firstWindow.rootViewController
    }
    
    static func getImageFullUrl(_ photo: String) -> String {
        return "\(Constants.baseImageUrl)/\(photo)"
    }
    
    static func getToken() -> String? {
        return Messaging.messaging().fcmToken
    }
}
