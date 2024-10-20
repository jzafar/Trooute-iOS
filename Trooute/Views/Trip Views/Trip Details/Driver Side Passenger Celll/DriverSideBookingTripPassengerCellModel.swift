//
//  DriverSideBookingTripPassengerCellModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

import Foundation
class DriverSideBookingTripPassengerCellModel {
    var booking: Booking
    init (booking: Booking) {
        self.booking = booking
    }
    
    func getDriverModel(user: User) -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: user)
    }
    
    var status: BookingStatus {
        return booking.status
    }
    
    var bookingId: String {
        return "Booking # \(booking.id.firstTenCharacters())"
    }
    
    var departureDate: String {
        if let date = booking.tripData?.departureDate.fullFormate() {
            return date
        }
        return Date().fullFormatDate()
    }
    
    
    func bookPrice() -> String {
        let amount = self.booking.amount - Double(booking.numberOfSeats)
        return "€\(String(format: "%.1f", amount))"
        
    }
    
    func finalPrice() -> Double {
        return self.booking.amount - Double(booking.numberOfSeats) * 2
    }
}
