//
//  SearchResults.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI

struct SearchResults: View {
    @StateObject var viewModel = SearchResultsViewModel()

        var body: some View {
            NavigationView {
                List(viewModel.trips) { trip in
                    TripCardView(viewModel: TripCardViewModel(trip: trip))
                }
                .onAppear {
                    viewModel.fetchTrips()
                }
                .navigationTitle("Trips around you")
            }
        }
}

#Preview {
    SearchResults()
}
