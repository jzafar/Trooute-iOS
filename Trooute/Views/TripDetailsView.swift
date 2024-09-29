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

            Section(header: CustomHeaderView(seats: viewModel.availableSeats), content: {
                passengersView()
            })

            Section(header: TextViewLableText(text: "Destination and schedule", textFont: .headline))
                {
                    destinationView()
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                }

            Section(header: TextViewLableText(text: "Trip Details", textFont: .headline)) {
                tripDetails()
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

    @ViewBuilder
    func tripDetails() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Restrictions on luggage type and weight")
                .foregroundStyle(.gray)
                .padding(.top, 10)
                .padding(.horizontal)
            MasterDetailsView(master: "Type", details: "Hand carry")
            MasterDetailsView(master: "weight", details: viewModel.handCarryWeight)
            MasterDetailsView(master: "Type", details: "Suitcase")
            MasterDetailsView(master: "weight", details: viewModel.suitcaseWeight)
            Divider()
                .padding(.horizontal)
            MasterDetailsView(master: "Smoking Allowed", details: viewModel.smokingPreference)
            MasterDetailsView(master: "Pets Allowed", details: viewModel.petPreference)
            MasterDetailsView(master: "Language", details: viewModel.languagePreference)
            Divider()
                .padding(.horizontal)
            Text("Other relevent details")
                .foregroundStyle(.gray)
                .padding(.horizontal)
            Text(viewModel.otherReliventDetails)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.bottom)
        }.background(.white)
            .cornerRadius(25)
    }

    @ViewBuilder
    func destinationView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading, spacing: 10) {
                TripRouteView(info: viewModel.getDestinationModel())
                    .padding(.top)
            }
            .background(Color.white)
            .cornerRadius(10)
            PriceView(price: viewModel.trip.pricePerPerson, bookingSeats: nil, showPersonText: true)
        }
        .background(Color("TitleColor"))
        .shadow(radius: 10)
        .cornerRadius(15)
    }

    @ViewBuilder
    func passengersView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Passengers not available")
                    .foregroundStyle(.gray)
            }
            Divider()

            HStack {
                Text("You might share the ride with fellow passengers heading the same way")
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    let data = MockDate.getTripsResponse()?.data?.first
    TripDetailsView(viewModel: TripDetailsViewModel(trip: data!))
}

struct CustomHeaderView: View {
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
