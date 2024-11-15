//
//  BookingsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import Foundation
import SwiftUI
import SwiftLoader
class BookingsViewModel: ObservableObject {
    @Published var bookings: [BookingData] = []
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    private let repository = GetBookingRepository()
    
    
    func getBookings() {
        SwiftLoader.show(title: String(localized:"Loading..."), animated: true)
        repository.getBookings { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success,
                let bookings = response.data.data {
                    self?.bookings = bookings.reversed()
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
        
        
//        if let driverMode = user?.driverMode {
//            if let bookingResponse = driverMode ? MockDate.getDriverBookingsResponse() :  MockDate.getUserBookingsResponse() {
//                if bookingResponse.success {
//                    self.bookings = bookingResponse.data!
//                }
//            }
//        }
        
    }
}
