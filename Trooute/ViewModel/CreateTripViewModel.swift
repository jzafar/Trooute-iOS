//
//  CreateTripViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Foundation
class CreateTripViewModel: ObservableObject {
    @Published var fromLocation: String = ""
    @Published var toLocation: String = ""
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    
    @Published var seatsAvailable: Int = 1
    @Published var pricePerPerson = 0 // Price will be taken as a string initially
    @Published var handCarryWeight: String = ""
    @Published var suitcaseWeight: String = ""
    @Published var isSmokingAllowed: Bool = false
    @Published var arePetsAllowed: Bool = false
    @Published var isLanguageRequired: Bool = false
    @Published var languagePreference: String = ""
    @Published var otherReleventDetails: String = ""
    
    
    var currencyFormatter: NumberFormatter {
            let fmt = NumberFormatter()
            fmt.numberStyle = .currency
            fmt.minimumFractionDigits = 2
            fmt.maximumFractionDigits = 2
            fmt.locale = Locale.current
            return fmt
        }
    
    
    func postTrip() {
        
    }
}
