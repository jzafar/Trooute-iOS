//
//  WishView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//

import SwiftUI

struct WishView: View {
    @StateObject var viewModel = WishViewModel()
    var body: some View {
        List {
            ForEach(viewModel.wishList) { wish in
                ZStack {
                    NavigationLink(destination: TripDetailsView(viewModel: TripDetailsViewModel(tripId: wish.id))) {
                            EmptyView()
                            }.opacity(0)
                    Section {
                        DriverTripCell(trip: wish)
                    }.listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }.listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                
            }
        }.listStyle(GroupedListStyle())
        .onAppear {
            Tabbar.shared.hide = true
            viewModel.getWishList()
        }.navigationTitle("Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
    }
}

//#Preview {
//    WishView()
//}
