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
            switch result {
            case .success(let respponse):
                if respponse.data.success {
                    if let trips = respponse.data.data {
                        self?.wishList = trips
                    }
                } else {
                    BannerHelper.displayBanner(.error, message: respponse.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
}
