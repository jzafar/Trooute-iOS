//
//  ProceedViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation

class ProceedViewModel {
    let trip: TripsData
    let totalPrice: Double
    let numberOfSeats: Int
    init(trip: TripsData, numberOfSeats: Int) {
        self.trip = trip
        self.numberOfSeats = numberOfSeats
        totalPrice = Double(numberOfSeats) * self.trip.pricePerPerson + Double(numberOfSeats)
    }
}
