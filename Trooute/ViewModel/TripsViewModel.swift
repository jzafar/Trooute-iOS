//
//  TripsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//

import Foundation

class TripsViewModel: ObservableObject {
    @Published var fromLocation: String = ""
    @Published var toLocation: String = ""
    @Published var distanceFrom: Double = 2
    @Published var distanceTo: Double = 2
    @Published var date: Date? = nil
    @Published var isDatePickerPresented: Bool = false
    @Published var isFlexibleDate: Bool = false
    @Published var flexibleDays: Int = 1
    
    @Published var showFloatingDistanceForFrom: Bool = false
    @Published var showFloatingDistanceForTo: Bool = false
    @Published var sheetHeight: CGFloat = .zero

    
    @Published var nearByTrips: [TripsData] = []
    
    func fetchTrips() {
        let tripResponse = MockDate.getTripsResponse()!
        if tripResponse.success == true,
        let trips = tripResponse.data{
            self.nearByTrips = trips
        }
    }
}
