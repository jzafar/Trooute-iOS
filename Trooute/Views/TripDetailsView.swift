//
//  TripDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-27.
//

import SwiftUI

struct TripDetailsView: View {
    @ObservedObject var viewModel: TripDetailsViewModel
    var body: some View {
        List {
            if let driver = viewModel.trip?.driver {
                Section {
                    UserInfoCardView(viewModel: viewModel.getDriverModel(driver: driver))
                }
            }
            if let carDetails = viewModel.trip?.driver?.carDetails {
                Section {
                    CarInfoView(viewModel: viewModel.getCarDetailsModel(carDetails: carDetails))
                }
            }

            Section(header: PassengersSectionHeader(seats: viewModel.availableSeats), content: {
                TripDetailsViewComponents.passengersView()
            })

            if let trip = viewModel.trip {
                Section(header: TextViewLableText(text: "Destination and schedule", textFont: .headline))
                    {
                        DestinationView(destination: viewModel.getDestinationModel(trip: trip), price: trip.pricePerPerson)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                    }
            }
            

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
        .safeAreaInset(edge: .bottom) {
            if let trip = viewModel.trip {
                bookNowView(trip)
            }
        }
        .onAppear {
            Tabbar.shared.hide = true
            viewModel.onApplear()
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func bookNowView(_ trip: TripsData) -> some View {
        VStack {
            HStack {
                Image("ic_heart")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                NavigationLink(destination: BookTripView(viewModel: BookTripViewModel(trip: trip))) {
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
    TripDetailsView(viewModel: TripDetailsViewModel(tripId: data!.id))
}

struct PassengersSectionHeader: View {
    let title: String = "Passengers"
    let seats: String

    var body: some View {
        HStack {
            TextViewLableText(text: title, textFont: .headline)
            Spacer()
            Text("\(seats) Seats Available")
                .font(.footnote)
                .foregroundStyle(.darkBlue)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
        }.padding(.bottom, 10)
    }
}
