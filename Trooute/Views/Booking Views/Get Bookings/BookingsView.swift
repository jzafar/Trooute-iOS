//
//  BookingsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct BookingsView: View {
    @StateObject var viewModel = BookingsViewModel()
    var body: some View {
        VStack {
            if viewModel.bookings.count == 0 {
                HStack {
                    Spacer()
                    Text("You don't have any bookings")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.vertical)
                    Spacer()
                }.listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                List {
                    ForEach(viewModel.bookings) { booking in
                            ZStack {
                                NavigationLink(destination: BookingDetailsView(viewModel: BookingDetailsViewModel(bookingId: booking.id))) {
                                    EmptyView()
                                    }.opacity(0)
                                BookingCardView(viewModel: BookingCardViewModel(booking: booking))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }.background(.clear)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }.listStyle(GroupedListStyle())
                    .refreshable {
                        viewModel.getBookings()
                    }
            }
            
        }
        .onAppear {
            viewModel.getBookings()
        }
    }
}

//#Preview {
//    BookingsView()
//}
