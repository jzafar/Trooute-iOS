//
//  ProceedViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
import SwiftLoader

class ProceedViewModel: ObservableObject {
    let trip: TripsData
    let totalPrice: Double
    let numberOfSeats: Int
    private let pickupLocation: BookingPickupLocation
    private let repository = ProceedRepository()
    private let note: String
    @Published var showSuccessView = false
    init(trip: TripsData, numberOfSeats: Int, pickupLocation: BookingPickupLocation, note: String) {
        self.trip = trip
        self.numberOfSeats = numberOfSeats
        totalPrice = Double(numberOfSeats) * self.trip.pricePerPerson + Double(numberOfSeats)
        self.pickupLocation = pickupLocation
        self.note = note
    }
    
    func bookNoewPressed() {
        SwiftLoader.show(animated: true)
        let request = CreateBookingRequest(amount: totalPrice, note: note, numberOfSeats: numberOfSeats, pickupLocation: pickupLocation, trip: trip.id, plateFormFee: Double(numberOfSeats) * 1.0)
        repository.createBooking(request: request) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success {
                    self?.showSuccessView = true
                } else {
                    BannerHelper.displayBanner(.error, message:  response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message:  failure.localizedDescription)
            }
        }
    }
}
