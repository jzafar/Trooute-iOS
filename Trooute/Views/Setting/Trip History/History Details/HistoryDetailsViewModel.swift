//
//  HistoryDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-03.
//
import Foundation
import SwiftLoader
class HistoryDetailsViewModel: ObservableObject {
    @Published var tripsData: TripsData? {
        didSet {
            calculateHandCarryWeight()
            calculateSuitcaseWeight()
            updateSmokingPreference()
            updatePetPreference()
            updateLanguagePreference()
            updateOtherReliventDetails()
        }
    }

    @Published var handCarryWeight = "Not Provided"
    @Published var suitcaseWeight = "Not Provided"
    @Published var smokingPreference: String = "NO"
    @Published var petPreference: String = "NO"
    @Published var languagePreference: String = "Not Provided"
    @Published var otherReliventDetails: String = "Not Provided"
    private var userModel = UserUtils.shared
    private let repository = TripHistoryRepository()
    var tripId: String
    init(tripId: String) {
        self.tripId = tripId
    }

    func onAppear() {
        SwiftLoader.show(title: "Loading...", animated: true)
        repository.getTripDetails(tripId: tripId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success,
                   let tripDetails = response.data.data {
                    self?.tripsData = tripDetails
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case let .failure(failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    func getDriverModel(driver: Driver) -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: driver)
    }

    func getCarDetailsModel(carDetails: CarDetails) -> CarInfoViewModel {
        return CarInfoViewModel(carDetails: carDetails)
    }

    func bookingCardVM(booking: Booking) -> DriverSideBookingTripPassengerCellModel {
        return DriverSideBookingTripPassengerCellModel(booking: booking, isHistory: true)
    }
    
    func getDestinationModel(trip: Trip) -> TripRouteModel {
        let fromAddress = trip.fromAddress
        let whereToAddress = trip.whereToAddress
        let departureDate = trip.departureDate
        return TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: departureDate)
    }
    
    func getPassengerDestinationModel(trip: TripsData) -> TripRouteModel? {
        if let fromAddress = trip.fromAddress,
        let whereToAddress = trip.whereToAddress,
        let departureDate = trip.departureDate {
            return TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: departureDate)
        }
        return nil
    }

    private func calculateHandCarryWeight() {
        if userModel.driverMode {
            if let handCarryLuggage = tripsData?.trip?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
               let weight = handCarryLuggage.weight {
                handCarryWeight = "\(weight) KG"
            }
        } else {
            if let handCarryLuggage = tripsData?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
               let weight = handCarryLuggage.weight {
                handCarryWeight = "\(weight) KG"
            }
        }
        
    }

    private func calculateSuitcaseWeight() {
        if userModel.driverMode {
            if let handCarryLuggage = tripsData?.trip?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
               let weight = handCarryLuggage.weight {
                suitcaseWeight = "\(weight) KG"
            }
        } else {
            if let handCarryLuggage = tripsData?.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
               let weight = handCarryLuggage.weight {
                suitcaseWeight = "\(weight) KG"
            }
        }
    }

    private func updateSmokingPreference() {
        if userModel.driverMode {
            smokingPreference = tripsData?.trip?.smokingPreference ?? false ? "Yes" : "No"
        } else {
            smokingPreference = tripsData?.smokingPreference ?? false ? "Yes" : "No"
        }
    }

    private func updatePetPreference() {
        if userModel.driverMode {
            petPreference = tripsData?.trip?.petPreference ?? false ? "Yes" : "No"
        } else {
            petPreference = tripsData?.petPreference ?? false ? "Yes" : "No"
        }
    }

    private func updateLanguagePreference() {
        if userModel.driverMode {
            languagePreference = tripsData?.trip?.languagePreference ?? "Not Provided"
        } else {
            languagePreference = tripsData?.languagePreference ?? "Not Provided"
        }
    }

    private func updateOtherReliventDetails() {
        if userModel.driverMode {
            otherReliventDetails = tripsData?.trip?.note.emptyOrNil ?? "Not Provided"
        } else {
            otherReliventDetails = tripsData?.note.emptyOrNil ?? "Not Provided"
        }
    }
}
