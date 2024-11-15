//
//  TripHistoryViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-03.
//
import Foundation
import SwiftLoader

class TripHistoryViewModel: ObservableObject {
    @Published var trips: [TripsData] = []
    private let repositiry = TripHistoryRepository()
    
    func onAppear() {
        SwiftLoader.show(title: String(localized:"Loading..."), animated: true)
        self.repositiry.getTripHistory { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let resposne):
                if resposne.data.success,
                   let trips = resposne.data.data {
                    self?.trips = trips.reversed()
                } else {
                    BannerHelper.displayBanner(.error, message: resposne.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
}
