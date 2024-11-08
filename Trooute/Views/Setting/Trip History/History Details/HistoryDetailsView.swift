//
//  HistoryDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-03.
//

import SwiftUI

struct HistoryDetailsView: View {
    @StateObject var viewModel: HistoryDetailsViewModel
    var userModel = UserUtils.shared
    var body: some View {
        VStack {
            List {
                if let trip = viewModel.tripsData {
                    Section {
                        statusView()
                            .listRowInsets(EdgeInsets())
                    }

                    Section(header: TextViewLableText(text: "Passengers", textFont: .headline)) {
                        ForEach(viewModel.tripsData?.bookings ?? []) { booking in
                            DriverSideBookingTripPassengerCell(viewModel: viewModel.bookingCardVM(booking: booking))
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical)
                                .listRowSeparator(.hidden)
                        }
                    }

                    if !userModel.driverMode {
                        driverAndCarInfoView()
                        if let destination = viewModel.getPassengerDestinationModel(trip: trip) {
                            destinationView(destination: destination)
                        }
                    } else {
                        if let tripData = trip.trip {
                            let destination = viewModel.getDestinationModel(trip: tripData)
                            destinationView(destination: destination)
                        }
                    }

                    tripDetailsView()
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

        }.onAppear {
            viewModel.onAppear()
        }.onReceive(NotificationCenter.default.publisher(for: Notification.ReviewPosted)){ _ in
            viewModel.onAppear()
        }
        .navigationTitle(viewModel.tripId.firstTenCharacters())
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func destinationView(destination: TripRouteModel) -> some View {
        Section(header: TextViewLableText(text: "Destination and schedule", textFont: .headline)) {
            DestinationView(destination: destination, price: userModel.driverMode ? viewModel.tripsData?.trip?.pricePerPerson ?? 0.0 : viewModel.tripsData?.pricePerPerson ?? 0.0)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
        }
    }

    @ViewBuilder
    func tripDetailsView() -> some View {
        Section(header: TextViewLableText(text: "Trip Details", textFont: .headline)) {
            TripPrefView(handCarryWeight: viewModel.handCarryWeight,
                         suitcaseWeight: viewModel.suitcaseWeight,
                         smokingPreference: viewModel.smokingPreference,
                         petPreference: viewModel.petPreference,
                         languagePreference: viewModel.languagePreference,
                         otherReliventDetails: viewModel.otherReliventDetails)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
        }
    }

    @ViewBuilder
    func driverAndCarInfoView() -> some View {
        if let trip = viewModel.tripsData {
            if let driver = trip.driver {
                Section {
                    UserInfoCardView(viewModel: viewModel.getDriverModel(driver: driver))
                }
            }
            if let carDetails = trip.driver?.carDetails {
                Section {
                    CarInfoView(viewModel: viewModel.getCarDetailsModel(carDetails: carDetails))
                }
            }
        }
    }

    @ViewBuilder
    func statusView() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Image("ic_completed_check")
                        Text("Completed")
                            .font(.body)
                    }.padding(.top, 5)
                    Text("Trip successfully completed. Thank you for riding with us!")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 3)
                    Text("Trip # \(viewModel.tripId.uppercased())")
                    Text(viewModel.tripsData?.trip?.departureDate.fullFormate() ?? "")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 5)
                }.padding(.horizontal)

            }.cornerRadius(15)
                .background(.white)
            if userModel.driverMode {
                PriceView(price: viewModel.tripsData?.trip?.totalAmount ?? 0.0, bookingSeats: 0, showPersonText: false)
            } else {
                PriceView(price: viewModel.tripsData?.totalAmount ?? 0.0, bookingSeats: 0, showPersonText: false)
            }

        }.background(Color("TitleColor"))
            .cornerRadius(15)
    }
}

// #Preview {
//    HistoryDetailsView()
// }
