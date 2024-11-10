//
//  TripCardViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import Foundation
import SwiftUI
import SwiftLoader

class TripCardViewModel: ObservableObject {
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @Published var trip: TripsData
//    @Published var bookMarked = false
    @Published var showPersonText: Bool
    var bookingSeats: Int?
    private let repository = TripCardRepository()
    init(trip: TripsData, bookingSeats: Int? = nil, showPersonText: Bool = true) {
        self.trip = trip
        self.bookingSeats = bookingSeats
        self.showPersonText = showPersonText
    }
    
    func updateBookMark(wishList: [String]?) {
        self.user?.wishlist = wishList
        if let isAddedInWishList = trip.isAddedInWishList {
            trip.isAddedInWishList = !isAddedInWishList
        }
    }
    
    func addToWishList() {
        SwiftLoader.show(animated: true)
        repository.addToWishList(tripId: trip.id) { [weak self] result in
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
    
    var driverImageUrl: String {
        return "\(Constants.baseImageUrl)/\(self.trip.driver?.photo ?? "")"
    }
    
    func getTripRouteModel() -> TripRouteModel? {
        if let fromAddress = self.trip.fromAddress,
           let whereToAddress = self.trip.whereToAddress,
           let departureDate = self.trip.departureDate {
            return TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: departureDate)
        }
        return nil
    }
    
    var bookPrice: String {
        if let seats = self.bookingSeats {
            return "€\(String(format: "%.1f", Double(seats) * (trip.pricePerPerson ?? 0.0)))"
        }
        return "€0.0"
    }
    
    var finalPrice: Double {
        if let seats = self.bookingSeats {
            return  Double(seats) * (trip.pricePerPerson ?? 0.0)
        }
        return self.trip.pricePerPerson ?? 0.0
    }
}
