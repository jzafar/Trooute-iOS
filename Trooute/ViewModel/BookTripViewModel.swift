//
//  BookTripViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation

class BookTripViewModel: ObservableObject {
    @Published var pickupLocation: String = ""
    @Published var otherReleventDetails: String = ""
    @Published var totalPerson: Int = 1
    @Published var totalPrice: Double = 0.0
    
    let trip: TripsData
    init(trip: TripsData) {
        self.trip = trip
        self.updatePrice()
    }
    
    func updatePrice() {
        totalPrice = self.trip.pricePerPerson * Double(totalPerson)
    }
}
