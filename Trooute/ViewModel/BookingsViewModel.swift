//
//  BookingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import Foundation
class BookingsViewModel: ObservableObject {
    @Published var bookings: [BookingData] = []
    
    func getBookings() {
        if let bookingResponse = MockDate.getUserBookingsResponse() {
            if bookingResponse.success {
                self.bookings = bookingResponse.data!
            }
        }
    }
}
