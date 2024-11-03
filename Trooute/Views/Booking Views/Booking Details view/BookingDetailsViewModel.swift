//
//  BookingDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import Foundation
import SwiftUI
import SwiftLoader

class BookingDetailsViewModel: ObservableObject {
    private var bookingId: String
    @Published var bookingData: BookingData? {
        didSet {
            self.setDepartureDate()
            self.handCarryWeight = self.getHandCarryWeight()
            self.suitcaseWeight = self.getSuitcaseWeight()
            self.bookingID = "Booking # \(self.bookingId.firstTenCharacters())"
            self.finalPrice = self.getFinalPrice()
        }
    }
    @Published var status: BookingStatus = .waiting
    @Published var departureDate = ""
    @Published var availableSeats = ""
    @Published var bookingID: String? = ""
    @Published var showPaymentsScreen = false
    @Published var suitcaseWeight = "Not Provided"
    @Published var handCarryWeight = "Not Provided"
    @Published var popView = false
    @Published var passgenerId: String?
    @Published var finalPrice: Double = 0.0
    @Published var currentBooking: Booking? = nil
    let user = UserUtils.shared
    private let repository = BookingDetailsRepository()
    private var paymentUrl: String? = nil
    private var timer: Timer?
    init(bookingId: String) {
        self.bookingId = bookingId
        
    }
    
    func getBookingDetails() {
        SwiftLoader.show(title: "Loading...", animated: true)
        repository.getBookingDetails(bookingId: self.bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success,
                   let bookingData = response.data.data {
                    self?.bookingData = bookingData
                    self?.status = bookingData.status ?? .waiting
                    self?.availableSeats = "\(bookingData.numberOfSeats ?? 0)"
                    self?.checkPickupStatus()
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    func checkPickupStatus() {
        if !user.driverMode &&
            bookingData?.trip.status == .PickupStarted &&
            bookingData?.status == .confirmed {
            if let tripId = self.bookingData?.trip.id {
                self.getPickUpStatus(tripId: tripId)
            }
            startTimer()
        }
    }
    func getDriverMode() -> Bool {
        return user.driverMode
    }
    
    func bookPrice() -> Double {
        if let price = self.bookingData?.trip.pricePerPerson {
            return price * Double(self.bookingData?.numberOfSeats ?? 0)
        }
        return 0.0
        
        
    }
    
    func getFinalPrice() -> Double{
        if user.driverMode { // Details from tabbar booking -> booking details
            let pricePerPerson = self.bookingData?.trip.pricePerPerson ?? 0.0
            let numberOfSeats = Double(self.bookingData?.numberOfSeats ?? 0)
            let price = (pricePerPerson * numberOfSeats) -  numberOfSeats
            return price
        } else {
            return self.bookingData?.amount ?? 0.0
        }
    }
    
    func setDepartureDate() {
        self.departureDate = bookingData?.trip.departureDate.fullFormate() ?? bookingData?.trip.departureDate ?? "Unknown"
    }
    
    
    func getStatu(_ driverMode: Bool) -> (Image, String) {
        return Utils.checkStatus(isDriverApproved: driverMode, status: status)
    }
    
    func getHandCarryWeight() -> String {
        if let handCarryLuggage = bookingData?.trip.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
           let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }
        
        return "Not Provided"
    }
    
    func getSuitcaseWeight() -> String {
        if let handCarryLuggage = bookingData?.trip.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
           let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }
        
        return "Not Provided"
    }
    
    var smokingPreference: String {
        return bookingData?.trip.smokingPreference ?? false ? "Yes" : "No"
    }
    
    var petPreference: String {
        return bookingData?.trip.petPreference ?? false ? "Yes" : "No"
    }
    
    var languagePreference: String {
        return bookingData?.trip.languagePreference ?? "Not Provided"
    }
    
    var otherReliventDetails: String {
        return bookingData?.trip.note.emptyOrNil ?? "Not Provided"
    }
    
    func getDestinationModel() -> TripRouteModel? {
        if let fromAddress = bookingData?.trip.fromAddress,
           let whereToAddress = bookingData?.trip.whereToAddress,
           let departureDate = bookingData?.trip.departureDate {
            return TripRouteModel(fromAddress: fromAddress, whereToAddress:  whereToAddress, date: departureDate)
        }
        return nil
    }
    
    func getStatusText(isDriver: Bool, status: BookingStatus) -> String {
        var str = ""
        if isDriver {
            if status == .waiting {
                str = "Passenger is waiting for your respnse."
            } else if status == .approved {
                str = "We are waiting for payments."
            } else if status == .confirmed {
                str = "This booking is now confirmed! Anticipate the upcomming trip day."
            } else if status == .canceled {
                str = "Booking canceled. We're Sorry for the Inconvenience."
            }
        } else {
            if status == .waiting {
                str = "We’ll notify you as soon as your booking is confirmed."
            } else if status == .approved {
                str = "Your booking is approved! Please proceed with payment to confirm."
            } else if status == .confirmed {
                str = "Your booking is now confirmed! Anticipate the upcoming trip day."
            } else if status == .canceled {
                str = "Booking canceled. We're Sorry for the Inconvenience."
            }
        }
        return str
    }
    
    func makePayments() {
        SwiftLoader.show(title:"Loading...",animated: true)
        repository.confirmBooking(bookingId: self.bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success,
                   let url = response.data.url {
                    self?.paymentUrl = url
                    self?.showPaymentsScreen = true
                    print(url)
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
        
    }
    
    func cancelBooking() {
        SwiftLoader.show(animated: true)
        repository.cancelBooking(bookingId: bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success {
                    self?.popView = true
                    BannerHelper.displayBanner(.success, message: response.data.message)
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    func getWebViewModel() -> WebViewModel {
        return WebViewModel(url: self.paymentUrl ?? "")
    }
    
    func acceptBooking() {
        if bookingData?.trip.driver?.stripeConnectedAccountId == nil {
            BannerHelper.displayBanner(.error, message: "You can\'t accept this booking. You must have to connect your stripe account to accept this booking. When we have approved you as a driver, we send you an email to connect your stripe account.")
            return
        }
        SwiftLoader.show(animated: true)
        repository.approveBooking(bookingId: self.bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success {
                    self?.getBookingDetails()
                    BannerHelper.displayBanner(.success, message: response.data.message)
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    func onTapPassenger(id: String) {
        self.passgenerId = id
    }
    
    func stopTimerIfRunning() {
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer() {
        if let tripId = self.bookingData?.trip.id {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { timer in
                print("\(timer)")
                self.getPickUpStatus(tripId: tripId)
            })
        }
        
    }
    
    func getPickUpStatus(tripId: String) {
        self.repository.getPickupStatus(tripId: tripId) { [weak self] result in
            switch result {
            case .success(let response):
                if response.data.success,
                   let tripData = response.data.data {
                    if let booking = tripData.bookings?.first(where: { $0.id == self?.bookingId }) {
                        self?.currentBooking = booking
                    }
                }
            case .failure(let failure):
                log.error("fail to load status \(failure.localizedDescription)")
            }
        }
    }
    
    func updatePickUpStatus(status: PickUpPassengersStatus) {
        
        if let tripId = currentBooking?.trip?.id,
           let pickupStatusId = currentBooking?.pickupStatus?.id {
            let requst = UpdatePickupStatusRequest(tripId: tripId, bookingId: self.bookingId, pickupStatus: status.rawValue, pickupId: pickupStatusId)
            SwiftLoader.show(title: "Updating...", animated: true)
            self.repository.updatePickupStatus(request: requst) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success {
                        BannerHelper.displayBanner(.success, message: "Status updated successfully")
                        self?.getPickUpStatus(tripId: tripId)
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
