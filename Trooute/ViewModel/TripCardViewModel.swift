//
//  TripCardViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation
class TripCardViewModel: ObservableObject {
    @Published var trip: TripsData
    var bookingSeats: Int?
    init(trip: TripsData, bookingSeats: Int? = nil) {
        self.trip = trip
        self.bookingSeats = bookingSeats
    }
    
    var driverImageUrl: String {
        return "\(Constants.baseImageUrl)/\(self.trip.driver?.photo ?? "")"
    }
    
    func getTripRouteModel() -> TripRouteModel {
        return TripRouteModel(fromAddress: self.trip.fromAddress, whereToAddress: self.trip.whereToAddress, date: self.trip.departureDate)
    }
    
    var bookPrice: String {
        if let seats = self.bookingSeats {
            return "€\(String(format: "%.1f", Double(seats) * trip.pricePerPerson))"
        }
        return "€0.0"
    }
    
    var finalPrice: Double {
        if let seats = self.bookingSeats {
            return  Double(seats) * trip.pricePerPerson
        }
        return self.trip.pricePerPerson
    }
}
