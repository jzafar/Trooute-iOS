//
//  SearchResultsModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//
import Foundation
class SearchResultsViewModel: ObservableObject {
    @Published var trips: [TripsData] = []
    
    func fetchTrips() {
        let tripResponse = MockDate.getTripsResponse()!
        if tripResponse.success == true,
        let trips = tripResponse.data{
            self.trips = trips
        }
    }
}
