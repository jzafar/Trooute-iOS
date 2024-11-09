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
    private let notification = Notifications()
    private let note: String
    @Published var showSuccessView = false
    init(trip: TripsData, numberOfSeats: Int, pickupLocation: BookingPickupLocation, note: String) {
        self.trip = trip
        self.numberOfSeats = numberOfSeats
        totalPrice = Double(numberOfSeats) * (self.trip.pricePerPerson ?? 0.0) + Double(numberOfSeats)
        self.pickupLocation = pickupLocation
        self.note = note
    }
    
    func bookNoewPressed() {
        SwiftLoader.show(animated: true)
        let request = CreateBookingRequest(amount: totalPrice, note: note, numberOfSeats: numberOfSeats, pickupLocation: pickupLocation, trip: trip.id, plateFormFee: Double(numberOfSeats) * 1.0)
        repository.createBooking(request: request) { [weak self] result in
            SwiftLoader.hide()
            guard let self = self else {return}
            switch result {
            case .success(let response):
                if response.data.success {
                    if let user = UserUtils.shared.user,
                       let driverID = self.trip.trip?.driver?.id {
                        self.notification.sendNotification(title: "Trip Booked", body: "Great news, Your trip is booked by \(user.name)", toId: "\(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(driverID)") { result1 in
                            switch result1 {
                            case .success(let success):
                                log.info("createBooking send notification successfully \(success) toid = \(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(driverID)")
                            case .failure(let failure1):
                                log.error("createBooking send notification fail \(failure1.localizedDescription)")
                            }
                            self.showSuccessView = true
                        }
                    } else {
                        self.showSuccessView = true
                    }
                } else {
                    BannerHelper.displayBanner(.error, message:  response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message:  failure.localizedDescription)
            }
        }
    }
}
