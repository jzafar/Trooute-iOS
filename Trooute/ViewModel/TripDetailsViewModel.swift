//
//  TripDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation

class TripDetailsViewModel: ObservableObject {
    private var tripId: String
    @Published var trip: TripsData? = nil
    init(tripId: String) {
        self.tripId = tripId
    }

    func onApplear() {
        if let bookingResponse = MockDate.getTripDetailsResponse() {
            if bookingResponse.success {
                trip = bookingResponse.data!
            }
        }
    }

    var availableSeats: String {
        return "\(trip?.availableSeats ?? 100)"
    }

    var handCarryWeight: String {
        if let handCarryLuggage = trip?.luggageRestrictions.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
           let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }

        return "Not Provided"
    }

    var suitcaseWeight: String {
        if let handCarryLuggage = trip?.luggageRestrictions.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
           let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }

        return "Not Provided"
    }

    var smokingPreference: String {
        return trip?.smokingPreference ?? false ? "Yes" : "No"
    }

    var petPreference: String {
        return trip?.petPreference ?? false ? "Yes" : "No"
    }

    var languagePreference: String {
        return trip?.languagePreference ?? "Not Provided"
    }

    var otherReliventDetails: String {
        return trip?.note?.emptyOrNil() ?? "Not Provided"
    }

    func getDriverModel(driver: Driver) -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: driver)
    }

    func getCarDetailsModel(carDetails: CarDetails) -> CarInfoViewModel {
        return CarInfoViewModel(carDetails: carDetails)
    }

    func getDestinationModel(trip: TripsData) -> TripRouteModel {
        return TripRouteModel(fromAddress: trip.fromAddress, whereToAddress: trip.whereToAddress, date: trip.departureDate)
    }

}
