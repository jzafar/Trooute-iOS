//
//  BookingCardViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation
import SwiftUI

class BookingCardViewModel: ObservableObject {
    @Published var booking: BookingData
    init(booking: BookingData) {
        self.booking = booking
    }
    
//    var driverImageUrl: String {
//        return "\(Constants.baseImageUrl)/\(self.trip.driver?.photo ?? "")"
//    }
    
    var status: String {
        return booking.status ?? "waiting"
    }
    
    var bookingId: String {
        return "Booking # \(booking.id.firstTenCharacters())"
    }
    
    var departureDate: String {
        let date = booking.trip.departureDate.fullFormate()
        return date
    }
    
    func getTripRouteModel() -> TripRouteModel {
        return TripRouteModel(fromAddress: self.booking.trip.fromAddress, whereToAddress: self.booking.trip.whereToAddress, date: self.booking.trip.departureDate)
    }
    
    func bookPrice(driverMode: Bool) -> String {
        if driverMode {
            return "€\(String(format: "%.1f", self.booking.trip.pricePerPerson ?? 0.0))"
        } else {
            return "€\(String(format: "%.1f", self.booking.amount ?? 0.0))"
        }
    }
    
    func finalPrice(_ driverMode: Bool) -> Double {
        if driverMode {
            return 0.0
        } else {
            return self.booking.amount ?? 0.0
        }
    }
    
    func getStatu(driverMode: Bool) -> (Image, String) {
       return Utils.checkStatus(isDriverApproved: driverMode, status: status)
    }
}
