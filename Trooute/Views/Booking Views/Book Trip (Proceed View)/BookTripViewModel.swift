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
    @Published var pickUpAddressInfo: SearchedLocation? = nil
    @Published var shouldNavigate = false
    var trip: TripsData
    init(trip: TripsData) {
        self.trip = trip
        self.updatePrice()
    }
    
    func updatePrice() {
        totalPrice = (self.trip.pricePerPerson ?? 0.0) * Double(totalPerson)
    }
    
    func updatePassengers() {
        if totalPerson < trip.availableSeats ?? 0 {
            totalPerson += 1
        } else {
            BannerHelper.displayBanner(.info, message: "No more seats are available")
        }
        
        self.updatePrice()
    }
    
    func proceedButtonPressed() {
        if pickUpAddressInfo == nil {
            BannerHelper.displayBanner(.info, message: "Pickup location field can't be blank")
        } else if(otherReleventDetails.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) {
            BannerHelper.displayBanner(.info, message: "Other relevant details field can't be blank")
        } else {
            self.shouldNavigate = true
        }
    }
    
    func showErrorAlert() {
        pickupLocation = ""
        BannerHelper.displayBanner(.error, message: "App could not get coordinates of this location. Please choose some other location or try again")
    }
    
    var proceedViewModel: ProceedViewModel? {
        if let pickUpAddressInfo = pickUpAddressInfo {
            let address =  (pickUpAddressInfo.title ?? "") + " " + (pickUpAddressInfo.subtitle ?? "")
            let  pickupLocation = BookingPickupLocation(address:address, location: [pickUpAddressInfo.coordinate.latitude.rounded(toPlaces: 4), pickUpAddressInfo.coordinate.longitude.rounded(toPlaces: 4)])
            return ProceedViewModel(trip: trip, numberOfSeats: totalPerson, pickupLocation: pickupLocation, note: otherReleventDetails)
        }
       
        return nil
    }
}
