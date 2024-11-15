//
//  CreateTripViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Foundation
import SwiftLoader

class CreateTripViewModel: ObservableObject {
    @Published var fromLocation: String = ""
    @Published var toLocation: String = ""
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    @Published var seatsAvailable: Int = 1
    @Published var pricePerPerson: Int = 0
    @Published var handCarryWeight: String = ""
    @Published var suitcaseWeight: String = ""
    @Published var isSmokingAllowed: Bool = false
    @Published var arePetsAllowed: Bool = false
    @Published var isLanguageRequired: Bool = false
    @Published var languagePreference: String = ""
    @Published var otherReleventDetails: String = ""
    
    @Published var fromAddressInfo: SearchedLocation? = nil
    @Published var whereToAddressInfo: SearchedLocation? = nil
    @Published var dissMissView = false
    
    private let repository = CreateTripRepository()
    var currencyFormatter: NumberFormatter {
            let fmt = NumberFormatter()
            fmt.numberStyle = .currency
            fmt.minimumFractionDigits = 2
            fmt.maximumFractionDigits = 2
            fmt.locale = Locale(identifier: "de_DE")
            fmt.currencyCode = "EUR"
            fmt.usesGroupingSeparator = true
            return fmt
        }
    
    func showErrorAlert() {
        BannerHelper.displayBanner(.error, message: String(localized:"App could not get coordinates of this location. Please choose some other location or try again"))
    }
    
    func postTrip() {
        guard let _ = getDate() else {
            BannerHelper.displayBanner(.info, message: String(localized:"Please select a valid date"))
            return
        }
        print(pricePerPerson)
        guard let fromAddressInfo = self.fromAddressInfo,
              let fromTitle = fromAddressInfo.title else {
            BannerHelper.displayBanner(.info, message: String(localized:"Start location field can't be blank"))
            return
        }
        
        guard let whereToAddressInfo = self.whereToAddressInfo,
              let whereTitle = whereToAddressInfo.title else {
            BannerHelper.displayBanner(.info, message: String(localized:"Destination location field can't be blank"))
            return
        }
        
        if pricePerPerson == 0 {
            BannerHelper.displayBanner(.info, message: String(localized:"Price field can't be blank"))
        } else if seatsAvailable >= 10 {
            BannerHelper.displayBanner(.info, message: String(localized:"Maximum number of passengers allowed are 10"))
        } else {
            guard let date = getDate() else {
                BannerHelper.displayBanner(.info, message: String(localized:"Please select a valid date"))
                return
            }
            let from = fromTitle + " \(fromAddressInfo.subtitle ?? "")"
            let whereTo = whereTitle + " \(whereToAddressInfo.subtitle ?? "")"
            let handCarry = LuggageRestrictions(type: .handCarry, weight: handCarryWeight.count > 0 ? Int(handCarryWeight) : nil)
            let suitCase = LuggageRestrictions(type: .suitCase, weight: suitcaseWeight.count > 0 ? Int(suitcaseWeight) : nil)
            let price: Double = Double(pricePerPerson)/100.0
            let request = CreateTripRequest(departureDate: date, from_address: from, from_location: [fromAddressInfo.coordinate.longitude, fromAddressInfo.coordinate.latitude], pricePerPerson: price, smokingPreference: isSmokingAllowed, petPreference: arePetsAllowed, roundTrip: false, status: "", totalSeats: seatsAvailable, whereTo_address: whereTo, whereTo_location: [whereToAddressInfo.coordinate.longitude, whereToAddressInfo.coordinate.latitude], languagePreference: languagePreference, luggageRestrictions: [handCarry, suitCase], note: otherReleventDetails)
            SwiftLoader.show(title: String(localized:"Creating trip..."), animated: true)
            repository.createTrip(request: request) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success {
                        self?.dissMissView = true
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
    
    private func getDate() -> String? {
        var calendar = Calendar.current
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = timeZone
        }
       
        if let combinedDate = calendar.date(
            bySettingHour: calendar.component(.hour, from: selectedTime),
            minute: calendar.component(.minute, from: selectedTime),
            second: calendar.component(.second, from: selectedTime),
            of: selectedDate
        ) {
            let dateFormatter = ISO8601DateFormatter()
            let dateString = dateFormatter.string(from: combinedDate)
            print("Combined date string sent to server: \(dateString)")
            return dateString
        }
        return nil
    }
   
}
