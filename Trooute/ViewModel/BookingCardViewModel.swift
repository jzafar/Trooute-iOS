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
    let userModel = UserUtils.shared
    @Published var totalPrice = ""
    init(booking: BookingData) {
        self.booking = booking
        self.bookPrice()
    }
    
    func onAppear() {
    }
    
    var status: BookingStatus {
        return booking.status ?? .waiting
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
    
    func bookPrice() {
        if userModel.driverMode {
            totalPrice = "€\(String(format: "%.1f", Double(self.booking.numberOfSeats ?? 0) * (self.booking.trip.pricePerPerson ?? 0.0)))"
        } else {
            totalPrice = "€\(String(format: "%.1f", self.booking.amount ?? 0.0))"
        }
    }
    
    func finalPrice() -> Double {
        if userModel.driverMode {
            return self.booking.trip.pricePerPerson ?? 0.0
        } else {
            return self.booking.amount ?? 0.0
        }
    }
    
    func getStatu(_ driverMode: Bool) -> (Image, String) {
       return Utils.checkStatus(isDriverApproved: driverMode, status: status)
    }
}
