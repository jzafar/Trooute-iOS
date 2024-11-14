//
//  ProceedView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import SwiftUI

struct ProceedView: View {
    @StateObject var viewModel: ProceedViewModel
    var body: some View {
        List {
            Section(header: TextViewLableText(text: "Booking Detail")) {
                TripCardView(viewModel: TripCardViewModel(trip: viewModel.trip, bookingSeats: viewModel.numberOfSeats, showPersonText: false)) // user booking
            }.listRowInsets(EdgeInsets())
        }.navigationTitle("Confirm Booking")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                bookNowView()
            }.navigationDestination(isPresented: $viewModel.showSuccessView) {
                BookingConfirmedView(trip: viewModel.trip, numberOfSeats: viewModel.numberOfSeats)
            }.toolbarRole(.editor)
    }

    @ViewBuilder
    func bookNowView() -> some View {
        VStack {
            HStack {
                Text("€\(String(format: "%.1f", viewModel.totalPrice))")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                PrimaryGreenButton(title: "Book now") {
                    viewModel.bookNoewPressed()
                }.padding(.horizontal)
            }.padding(.horizontal)
                .padding(.top, 20)

        }.background(Color("TitleColor").ignoresSafeArea(edges: .bottom))
    }
}

#Preview {
    let data = MockDate.getTripsResponse()?.data?.first
    ProceedView(viewModel: ProceedViewModel(trip: data!, numberOfSeats: 2, pickupLocation: BookingPickupLocation(address: "", location: [12.12, 12.12]), note: ""))
}
