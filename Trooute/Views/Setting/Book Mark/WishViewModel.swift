//
//  WishViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//
import Foundation
import SwiftLoader
class WishViewModel: ObservableObject {
    @Published var wishList: [TripsData] = []
    private let repository = WishViewRepository()
    func getWishList() {
        SwiftLoader.show(title: "Loading...", animated: true)
        repository.getTrips { [weak self] result in
            SwiftLoader.hide()
            guard let self = self else {return}
            switch result {
            case .success(let respponse):
                if respponse.data.success {
                    if let trips = respponse.data.data {
                        self.wishList = self.mapData(wishTrips: trips)
                    }
                } else {
                    BannerHelper.displayBanner(.error, message: respponse.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    func mapData(wishTrips: [TripInfo]) -> [TripsData] {
        var trips: [TripsData] = []
        for wish in wishTrips {
            let wishDate = TripsData(id: wish.id, availableSeats: Int(wish.availableSeats ?? 0.0), departureDate: wish.departureDate, fromAddress: wish.from_address, whereToAddress: wish.whereTo_address,pricePerPerson: wish.pricePerPerson, isAddedInWishList: wish.isAddedInWishList, passengers: wish.passengers)
            trips.append(wishDate)
        }
        return trips
    }
}

