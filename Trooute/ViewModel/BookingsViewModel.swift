//
//  BookingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import Foundation
import SwiftUI
class BookingsViewModel: ObservableObject {
    @Published var bookings: [BookingData] = []
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    func getBookings() {
        if let driverMode = user?.driverMode {
            if let bookingResponse = driverMode ? MockDate.getDriverBookingsResponse() :  MockDate.getUserBookingsResponse() {
                if bookingResponse.success {
                    self.bookings = bookingResponse.data!
                }
            }
        }
        
    }
}
