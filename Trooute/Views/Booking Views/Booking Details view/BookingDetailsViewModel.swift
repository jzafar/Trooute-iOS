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
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    private let repository = BookingDetailsRepository()
    private var paymentUrl: String? = nil
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
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    
    func getDriverMode() -> Bool {
        if let user = user,
            let driverMode = user.driverMode{
            return driverMode
        }
        return false
    }
    
    func bookPrice() -> Double {
        
            if let price = self.bookingData?.trip.pricePerPerson {
                return price * Double(self.bookingData?.numberOfSeats ?? 0)
            }
            return 0.0
           
        
    }
    
    func finalPrice(_ driverMode: Bool) -> Double {
        if driverMode {
            return ((self.bookingData?.trip.pricePerPerson ?? 0.0) -  Double(self.bookingData?.numberOfSeats ?? 0))
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
            }
        } else {
            if status == .waiting {
                str = "We’ll notify you as soon as your booking is confirmed."
            } else if status == .approved {
                str = "Your booking is approved! Please proceed with payment to confirm."
            } else if status == .confirmed {
                str = "Your booking is now confirmed! Anticipate the upcoming trip day."
            }
        }
        return str
    }
    
    func makePayments() {
        repository.confirmBooking(bookingId: self.bookingId) { [weak self] result in
            switch result {
            case .success(let response):
                if response.data.success,
                   let url = response.data.url {
                    self?.paymentUrl = url
                    self?.showPaymentsScreen = true
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
    
    func cancelBooking() {
        repository.cancelBooking(bookingId: bookingId) { [weak self] result in
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
}
