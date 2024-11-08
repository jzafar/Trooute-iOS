//
//  DriverSideBookingTripPassengerCellModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

import Foundation
class DriverSideBookingTripPassengerCellModel {
    var booking: Booking
    @Published var isHistory = false
    private var userModel = UserUtils.shared
    @Published var tripData: TripsData?
    init (booking: Booking, isHistory: Bool = false, tripData: TripsData? = nil) {
        self.booking = booking
        self.isHistory = isHistory
        self.tripData = tripData
    }
    
    func getDriverModel(user: User) -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: user, showUserContact: (booking.status == .confirmed && !isHistory))
    }
    
    var status: BookingStatus {
        return booking.status
    }
    
    var bookingId: String {
        return "Booking # \(booking.id.firstTenCharacters())"
    }
    
    var departureDate: String {
        if isHistory {
            return booking.updatedAt.fullFormate()
        } else {
            if let date = booking.tripData?.departureDate.fullFormate() {
                return date
            }
            return Date().fullFormatDate()
        }
       
    }
    
    
    func bookPrice() -> String {
        let amount = self.booking.amount - Double(booking.numberOfSeats)
        return "€\(String(format: "%.1f", amount))"
        
    }
    
    func finalPrice() -> Double {
        if isHistory && !userModel.driverMode {
            return self.booking.amount
        }
        return self.booking.amount - Double(booking.numberOfSeats) * 2
    }
}
