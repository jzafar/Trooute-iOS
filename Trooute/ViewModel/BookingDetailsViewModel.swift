//
//  BookingDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import Foundation
import SwiftUI
class BookingDetailsViewModel: ObservableObject {
    private var bookingId: String
    @Published var bookingData: BookingData?
    @Published var status: BookingStatus = .waiting
    @Published var departureDate = ""
    @Published var availableSeats = ""
    @Published var handCarryWeight: String = ""
    @Published var suitcaseWeight: String = ""
    @Published var bookingID: String? = ""
    @Published var showPaymentsScreen = false
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    init(bookingId: String) {
        self.bookingId = bookingId
        
    }
    
    func getBookingDetails() {
        if let driverMode = user?.driverMode {
            if let bookingResponse = driverMode ? MockDate.getDriverBookingDetailsResponse() :  MockDate.getUserBookingDetailsResponse() {
                if bookingResponse.success {
                    self.bookingData = bookingResponse.data!
                    self.status = bookingData?.status ?? .waiting
                    self.serDepartureDate()
                    self.availableSeats = "\(bookingData?.numberOfSeats ?? 0)"
                    self.handCarryWeight = self.getHandCarryWeight()
                    self.suitcaseWeight = self.getSuitcaseWeight()
                    self.bookingID = "Booking # \(self.bookingId.firstTenCharacters())"
                }
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
    
    func serDepartureDate() {
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
        self.showPaymentsScreen = true
    }
    
    func getWebViewModel() -> WebViewModel {
        return WebViewModel(url: "https://checkout.stripe.com/c/pay/cs_live_b1M0w5BBV1IhVnr5dKz1tvQATxAiBwMn34VT2ZxGq6LDtVWuOKuSQq03dQ#fidkdWxOYHwnPyd1blppbHNgWjA0S31jUE9BNDRjXV1Pa3xza1RHYHJnVUFiU0FvcTRPU0FvX2YyT0lVPXdHV0BLa2pPVGFuQWdKM01JPHNTcDBEXzNzanFJPX9xXG1BM1BTcG9WdWxCY1RDNTVwV3JEMDR3XycpJ2N3amhWYHdzYHcnP3F3cGApJ2lkfGpwcVF8dWAnPydocGlxbFpscWBoJyknYGtkZ2lgVWlkZmBtamlhYHd2Jz9xd3BgeCUl")
    }
}
