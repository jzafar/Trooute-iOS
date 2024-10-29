//
//  PickupPassengersViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-29.
//

import Foundation
import SwiftLoader

class PickupPassengersViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    let tripId: String
    var timer: Timer?
    private let repositiry = PickupPassengersRepository()
    init(tripId: String) {
        self.tripId = tripId
        
    }
    
    func onAppear() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getPickupStatus), userInfo: nil, repeats: false)
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    @objc func getPickupStatus() {
        repositiry.getPickupStatus(tripId: tripId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success,
                   let bookings = response.data.data?.bookings {
                    self?.bookings = bookings
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func openMapButtonPressed(location: PickupLocation) {
        
    }
    
    func notShowedUP() {
        
    }
    
    func markedAsPickup() {
        
    }
    
    func notifyPassengerToGetReady() {
        
    }
    
    func startTrip() {
        
    }
}
