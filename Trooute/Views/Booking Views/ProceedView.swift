//
//  ProceedView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import SwiftUI

struct ProceedView: View {
    var viewModel: ProceedViewModel
    var body: some View {
        VStack {
            List {
                Section(header: TextViewLableText(text: "Booking Detail")) {
                    TripCardView(viewModel: TripCardViewModel(trip: viewModel.trip, bookingSeats: viewModel.numberOfSeats))
                }.listRowInsets(EdgeInsets())
            }.navigationTitle("Confirm Booking")
                .navigationBarTitleDisplayMode(.inline)
                .safeAreaInset(edge: .bottom) {
                    bookNowView()
                }
        }
        .toolbarRole(.editor)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    func bookNowView() -> some View {
        VStack {
            HStack {
                Text("€\(String(format: "%.1f", viewModel.totalPrice))")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                NavigationLink(destination: BookingConfirmedView(trip: viewModel.trip)) {
                    PrimaryGreenText(title: "Book now")
                        .padding(.horizontal)
                }

            }.padding(.horizontal)
                .background(Color("TitleColor"))
                .frame(height: 100)

        }.background(Color("TitleColor"))
            .frame(height: 130)
    }
}

#Preview {
    let data = MockDate.getTripsResponse()?.data?.first
    ProceedView(viewModel: ProceedViewModel(trip: data!, numberOfSeats: 2))
}
