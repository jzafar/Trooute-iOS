//
//  TripCardViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation
class TripCardViewModel: ObservableObject {
    @Published var trip: TripsData
    
    init(trip: TripsData) {
        self.trip = trip
    }
    
    var driverImageUrl: String {
        return "\(Constants.baseImageUrl)/\(self.trip.driver?.photo ?? "")"
    }
    
    func getTripRouteModel() -> TripRouteModel {
        return TripRouteModel(fromAddress: self.trip.fromAddress, whereToAddress: self.trip.whereToAddress, date: self.trip.departureDate)
    }
}
