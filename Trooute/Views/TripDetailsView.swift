//
//  TripDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-27.
//

import SwiftUI

struct TripDetailsView: View {
    var viewModel: TripDetailsViewModel
    var body: some View {
        List {
            Section {
                UserInfoCardView(viewModel: viewModel.getDriverModel())
            }

            Section {
                CarInfoView(viewModel: viewModel.getCarDetailsModel())
            }

            Section(header: PassengersSectionHeader(seats: viewModel.availableSeats), content: {
                TripDetailsViewComponents.passengersView()
            })

            Section(header: TextViewLableText(text: "Destination and schedule", textFont: .headline))
                {
                    DestinationView(destination: viewModel.getDestinationModel(), price: viewModel.trip.pricePerPerson)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
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
            bookNowView()
        }
        .onAppear {
            Tabbar.shared.hide = true
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func bookNowView() -> some View {
        VStack {
            HStack {
                Image("ic_heart")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                NavigationLink(destination: BookTripView(viewModel: BookTripViewModel(trip: viewModel.trip))) {
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
    TripDetailsView(viewModel: TripDetailsViewModel(trip: data!))
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
