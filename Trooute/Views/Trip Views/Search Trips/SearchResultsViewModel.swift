//
//  SearchResultsModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//
import Foundation

class SearchResultsViewModel: ObservableObject {
    @Published var trips: [TripsData] = []
    init(trips: [TripsData]) {
        self.trips = trips
    }
}
