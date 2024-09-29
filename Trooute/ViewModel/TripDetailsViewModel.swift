//
//  TripDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation

class TripDetailsViewModel {
    let trip: TripsData
    @Published var bookTrip: TripsData? = nil
    init(trip: TripsData) {
        self.trip = trip
    }
    
    var availableSeats: String {
        return "\(trip.availableSeats)"
    }
    
    var handCarryWeight: String {
        if let handCarryLuggage = trip.luggageRestrictions.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
        let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }

        return "Not Provided"
    }
    
    var suitcaseWeight: String {
        if let handCarryLuggage = trip.luggageRestrictions.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
        let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }

        return "Not Provided"
    }
    
    var smokingPreference: String {
        return trip.smokingPreference ? "Yes" : "No"
    }
    
    var petPreference: String {
        return trip.petPreference ? "Yes" : "No"
    }
    
    var languagePreference: String {
        return trip.languagePreference ?? "Not Provided"
    }
    
    var otherReliventDetails: String {
        return trip.note?.emptyOrNil() ?? "Not Provided"
    }
    
    func getDriverModel() -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: self.trip.driver!) 
    }
    
    func getCarDetailsModel() -> CarInfoViewModel {
        return CarInfoViewModel(carDetails: trip.driver!.carDetails!)
    }
    
    func getDestinationModel() -> TripRouteModel {
        return TripRouteModel(fromAddress: self.trip.fromAddress, whereToAddress:  self.trip.whereToAddress, date: self.trip.departureDate)
    }
    
    func goToBookingView() {
        self.bookTrip = self.trip
    }
}
