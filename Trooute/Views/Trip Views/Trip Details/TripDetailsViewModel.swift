//
//  TripDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
import SwiftLoader
class TripDetailsViewModel: ObservableObject {
    private var tripId: String
    private var userModel: UserUtils = UserUtils.shared
    @Published var trip: TripsData? {
        didSet {
            calculateHandCarryWeight()
            calculateSuitcaseWeight()
            updateSmokingPreference()
            updatePetPreference()
            updateOtherReliventDetails()
        }
    }
    @Published var handCarryWeight = "Not Provided"
    @Published var suitcaseWeight = "Not Provided"
    @Published var smokingPreference: String = "NO"
    @Published var petPreference: String = "NO"
    @Published var languagePreference: String = "Not Provided"
    @Published var otherReliventDetails: String = "Not Provided"
    @Published var showLoader = true
    private let repositiry = TripDetailsRepository()
    init(tripId: String) {
        self.tripId = tripId
    }

    func onApplear() {
        SwiftLoader.show(title: "Loading...",animated: true)
        repositiry.getTripDetails(tripId: tripId) { [weak self] result in
            SwiftLoader.hide()
            self?.showLoader = false
            switch result {
            case .success(let response):
                if  response.data.success,
                    let res = response.data.data {
                    self?.trip = res
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }

    private func calculateHandCarryWeight() {
        if userModel.drivMode {
            if let handCarryLuggage = trip?.trip?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
               let weight = handCarryLuggage.weight {
                self.handCarryWeight = "\(weight) KG"
            }
        } else {
            if let handCarryLuggage = trip?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
               let weight = handCarryLuggage.weight {
                self.handCarryWeight = "\(weight) KG"
            }
        }
        
    }

    private func calculateSuitcaseWeight() {
        if userModel.drivMode {
            if let handCarryLuggage = trip?.trip?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
               let weight = handCarryLuggage.weight {
                self.suitcaseWeight =  "\(weight) KG"
            }
        } else {
            if let handCarryLuggage = trip?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
               let weight = handCarryLuggage.weight {
                self.suitcaseWeight =  "\(weight) KG"
            }
        }
        
    }

    private func updateSmokingPreference() {
        if userModel.drivMode {
            smokingPreference = trip?.trip?.smokingPreference ?? false ? "Yes" : "No"
        } else {
            smokingPreference = trip?.smokingPreference ?? false ? "Yes" : "No"
        }
        
    }
    
    private func updatePetPreference() {
        if userModel.drivMode {
            petPreference = trip?.trip?.petPreference ?? false ? "Yes" : "No"
        } else {
            petPreference = trip?.petPreference ?? false ? "Yes" : "No"
        }
        
    }

    private func updateLanguagePreference() {
        if userModel.drivMode {
            languagePreference =  trip?.trip?.languagePreference ?? "Not Provided"
        } else {
            languagePreference =  trip?.languagePreference ?? "Not Provided"
        }
        
    }

    private func updateOtherReliventDetails() {
        if userModel.drivMode {
            otherReliventDetails = trip?.trip?.note.emptyOrNil ?? "Not Provided"
        } else {
            otherReliventDetails = trip?.note.emptyOrNil ?? "Not Provided"
        }
        
    }

    func getDriverModel(driver: Driver) -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: driver)
    }

    func getCarDetailsModel(carDetails: CarDetails) -> CarInfoViewModel {
        return CarInfoViewModel(carDetails: carDetails)
    }

    func getDestinationModel(trip: TripsData) -> TripRouteModel? {
        if userModel.drivMode {
            if let fromAddress = trip.trip?.fromAddress,
               let whereToAddress = trip.trip?.whereToAddress,
               let departureDate = trip.trip?.departureDate{
                return TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: departureDate)
            }
        } else {
            if let fromAddress = trip.fromAddress,
               let whereToAddress = trip.whereToAddress,
               let departureDate = trip.departureDate{
                return TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: departureDate)
            }
        }
        return nil
    }
    
    func bookingCardVM(booking: Booking) -> DriverSideBookingTripPassengerCellModel {
        return DriverSideBookingTripPassengerCellModel(booking: booking)
    }

}
