//
//  TripDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
import SwiftLoader
class TripDetailsViewModel: ObservableObject {
    var tripId: String
    private var userModel: UserUtils = UserUtils.shared
    @Published var showAlert = false
    @Published var trip: TripsData? {
        didSet {
            calculateHandCarryWeight()
            calculateSuitcaseWeight()
            updateSmokingPreference()
            updatePetPreference()
            updateLanguagePreference()
            updateOtherReliventDetails()
        }
    }
    @Published var handCarryWeight = String(localized:"Not Provided")
    @Published var suitcaseWeight = String(localized:"Not Provided")
    @Published var smokingPreference: String = String(localized:"No")
    @Published var petPreference: String = String(localized:"No")
    @Published var languagePreference: String = String(localized:"Not Provided")
    @Published var otherReliventDetails: String = String(localized:"Not Provided")
    @Published var openDetailsView: Bool = false
    @Published var showPickUpPassengers = false
    @Published var passgenerId: String?
    var bookingId: String? = nil
    var alertTitle = ""
    var alertMessage = ""
    private let repository = TripDetailsRepository()
    private let notification = Notifications()
    init(tripId: String) {
        self.tripId = tripId
    }

    func onApplear() {
        SwiftLoader.show(title: String(localized:"Loading..."),animated: true)
        repository.getTripDetails(tripId: tripId) { [weak self] result in
            SwiftLoader.hide()
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
        if userModel.driverMode {
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
        if userModel.driverMode {
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
        if userModel.driverMode {
            smokingPreference = trip?.trip?.smokingPreference ?? false ? String(localized:"Yes") : String(localized:"No")
        } else {
            smokingPreference = trip?.smokingPreference ?? false ? String(localized:"Yes") : String(localized:"No")
        }
        
    }
    
    private func updatePetPreference() {
        if userModel.driverMode {
            petPreference = trip?.trip?.petPreference ?? false ? String(localized:"Yes") : String(localized:"No")
        } else {
            petPreference = trip?.petPreference ?? false ? String(localized:"Yes") : String(localized:"No")
        }
        
    }

    private func updateLanguagePreference() {
        if userModel.driverMode {
            languagePreference =  trip?.trip?.languagePreference ?? String(localized:"Not Provided")
        } else {
            languagePreference =  trip?.languagePreference ?? String(localized:"Not Provided")
        }
        
    }

    private func updateOtherReliventDetails() {
        if userModel.driverMode {
            otherReliventDetails = trip?.trip?.note.emptyOrNil ?? String(localized:"Not Provided")
        } else {
            otherReliventDetails = trip?.note.emptyOrNil ?? String(localized:"Not Provided")
        }
        
    }

    func getDriverModel(driver: Driver) -> UserInfoCardViewModel {
        return UserInfoCardViewModel(user: driver)
    }

    func getCarDetailsModel(carDetails: CarDetails) -> CarInfoViewModel {
        return CarInfoViewModel(carDetails: carDetails)
    }

    func getDestinationModel(trip: TripsData) -> TripRouteModel? {
        if userModel.driverMode {
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

    func pickUpPassengersPressed() {
        updateTripStatus(status: .PickupStarted) { result in
            if result {
                DispatchQueue.main.async {
                    self.showPickUpPassengers = true
                }
                
            }
        }
    }
    
    func endTrip() {
        updateTripStatus(status: .COMPLETED) { success in
            if success {
                self.sendNotification(title: String(localized:"Trip completed"), body: String(localized:"Congratulations! Your trip has successfully come to a memorable end by "), toId: self.trip?.bookings) { _ in
                    NavigationUtil.popToRootView(animated: true)
                }
            }
        }
    }
    
    func cancelTrip() {
        updateTripStatus(status: .CANCELED) { success in
            if success {
                self.sendNotification(title: String(localized:"Booking canceled"), body: String(localized:"Sorry, Your trip is canceled by "), toId: self.trip?.bookings) { _ in
                    NavigationUtil.popToRootView(animated: true)
                }
            }
        }
    }
    
    private func updateTripStatus(status: TripStatus, completion: @escaping (Bool) -> Void) {
        SwiftLoader.show(animated: true)
        repository.updateTripStatus(tripId: self.tripId, status: status) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success {
                    self?.showErroBanner(key: response.data.message, defaultMessage: response.data.message, defaultType: .success)
                    completion(true)
                } else {
                    self?.showErroBanner(key: response.data.message, defaultMessage: response.data.message, defaultType: .error)
                    completion(false)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func showErroBanner(key: String, defaultMessage: String , defaultType: BannerType) {
        if (key == "remaining_time_more_than_12h") {
            BannerHelper.displayBanner(.info, message: String(localized:"You can start picking up passengers 12 hours before the trip start time."))
        } else if (key == "invalid_status") {
            BannerHelper.displayBanner(.info, message: String(localized:"Invalid trip status."))
        } else if (key == "trip_status_INPROGRESS") {
            BannerHelper.displayBanner(.info, message: String(localized:"Update trip status to In Progress"))
        } else if (key == "trip_status_Canceled") {
            BannerHelper.displayBanner(.info, message: String(localized:"Update trip status to canceled"))
        } else if (key == "trip_status_PickupStarted") {
            //Don't show banner
        } else if (key == "trip_status_Completed") {
            BannerHelper.displayBanner(.success, message: String(localized:"Update trip status to completed, you can see this trip in your Trip History"))
        }
        else {
            BannerHelper.displayBanner(.error, message: defaultMessage)
        }
    }
    
    private func sendNotification(title: String, body: String, toId: [Booking]?, completion: @escaping (Bool) -> Void) {
        guard let toId = toId else {
                completion(false) // No notifications to send
                return
            }

            // Create a DispatchGroup to track the completion of each notification
            let dispatchGroup = DispatchGroup()
            var allSucceeded = true

            for booking in toId {
                if let user = userModel.user, let bUser = booking.user {
                    dispatchGroup.enter() // Enter the group for each notification
                    
                    notification.sendNotification(title: title, body: "\(body) \(user.name)", toId: "\(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(bUser.id)") { response in
                        switch response {
                        case .success:
                            log.info("End trip notification sent for user \(bUser.name)")
                        case .failure(let error):
                            log.error("Failed to send end trip notification for user \(bUser.name): \(error.localizedDescription)")
                            allSucceeded = false // Mark as failed if any notification fails
                        }
                        
                        dispatchGroup.leave() // Leave the group after handling the response
                    }
                }
            }

            // Wait until all notifications are processed before calling the completion handler
            dispatchGroup.notify(queue: .main) {
                completion(allSucceeded)
            }
    }
    
    func addToWishList() {
        SwiftLoader.show(animated: true)
        repository.addToWishList(tripId: tripId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success,
                   let user = response.data.data {
                    self?.updateBookMark(wishList: user.wishlist)
                } else {
                    BannerHelper.displayBanner(.error, message:  response.data.message)
                }
            case .failure(let error):
                BannerHelper.displayBanner(.error, message:  error.localizedDescription)
            }
        }
    }
    
    func updateBookMark(wishList: [String]?) {
//        self.userModel.user?.wishlist = wishList
        if let isAddedInWishList = trip?.isAddedInWishList {
            trip?.isAddedInWishList = !isAddedInWishList
        }
    }
    
    func onTapPassenger(id: String) {
        self.passgenerId = id
    }
}
