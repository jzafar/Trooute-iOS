//
//  PickupPassengersViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-29.
//

import Foundation
import SwiftLoader
import UIKit

class PickupPassengersViewModel: ObservableObject {
    let tripId: String
    var timer: Timer?
    private let repositiry = PickupPassengersRepository()
    @Published var tripData: TripsData? = nil
    init(tripId: String) {
        self.tripId = tripId
        SwiftLoader.show(title: String(localized:"Loading..."), animated: true)
        getPickupStatus()
    }

    func onAppear() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.getPickupStatus()
        })
    }

    func getPickupStatus() {
        repositiry.getPickupStatus(tripId: tripId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success,
                   let tripData = response.data.data {
                    self?.tripData = tripData
                }
            case let .failure(failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func openMapButtonPressed(location: PickupLocation) {
        if let loc = location.location?.coordinates,
           let lattitude = loc.first,
           let longitude = loc.last,
           let url = URL(string: "maps://?saddr=&daddr=\(lattitude),\(longitude)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                BannerHelper.displayBanner(.info, message: String(localized:"Please install apple maps app"))
            }
        }
    }

    func updatePickupStatus(booking: Booking, status: PickUpPassengersStatus) {
        if let pickupId = booking.pickupStatus?.id {
            SwiftLoader.show(title: String(localized:"Updating..."), animated: true)
            let requst = UpdatePickupStatusRequest(tripId: tripId, bookingId: booking.id, pickupStatus: status.rawValue, pickupId: pickupId)
            repositiry.updatePickupStatus(request: requst) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case let .success(response):
                    if response.data.success {
                        self?.getPickupStatus()
                        BannerHelper.displayBanner(.success, message: String(localized:"Status updated successfully"))
                    } else {
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case let .failure(failure):
                    BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                }
            }
        }
    }

    func startTrip() {
        if let bookings = tripData?.bookings {
            var allMarkedAsPickedUp = true
            for booking in bookings {
                if booking.pickupStatus?.passengerStatus != PickUpPassengersStatus.DriverPickedup &&
                    booking.pickupStatus?.driverStatus != PickUpPassengersStatus.PassengerNotShowedup {
                    allMarkedAsPickedUp = false
                }
            }
            if !allMarkedAsPickedUp {
                BannerHelper.displayBanner(.error, message: String(localized:"You can't start trip until all passengers are marked as picked up.\nIf a passenger is not showed up you need to mark as Not Showed Up"))
            } else {
                SwiftLoader.show(title: String(localized:"Updating..."), animated: true)
                self.repositiry.updateTripStatus(tripId: self.tripId, status: .IN_PROGRESS) { [weak self] result in
                    SwiftLoader.hide()
                    switch result {
                    case .success(let response):
                        if response.data.success {
                            self?.tripData?.status = .IN_PROGRESS
                        } else {
                            BannerHelper.displayBanner(.error, message: response.data.message)
                        }
                    case .failure(let failure):
                        BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                    }
                }
            }
        }
    }
    
    func endTrip() {
        SwiftLoader.show(title: String(localized:"Updating..."), animated: true)
        self.repositiry.updateTripStatus(tripId: self.tripId, status: .COMPLETED) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success {
                    self?.tripData?.status = .COMPLETED
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
}
