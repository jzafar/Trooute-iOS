//
//  SearchResults.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI

struct SearchResults: View {
    @StateObject var viewModel: SearchResultsViewModel
    @Environment(\.presentationMode) var presentationMode
        var body: some View {
            NavigationView {
                List(viewModel.trips) { trip in
                    ZStack {
                        NavigationLink(destination: TripDetailsView(viewModel: TripDetailsViewModel(tripId: trip.id))) { EmptyView() }.opacity(0)
                        TripCardView(viewModel: TripCardViewModel(trip: trip))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }.background(.clear)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }.listStyle(GroupedListStyle())
                .navigationTitle("Search Results")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        XMarkButton {
                            self.presentationMode.wrappedValue.dismiss()
                        }.padding()
                    }
                }
            }
        }
}

//#Preview {
//    SearchResults()
//}
