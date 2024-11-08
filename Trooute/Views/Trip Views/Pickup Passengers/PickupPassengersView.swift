//
//  PickupPassengersView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-29.
//

import SwiftUI

struct PickupPassengersView: View {
    @StateObject var viewModel: PickupPassengersViewModel
    @StateObject var userModel = UserUtils.shared
    var body: some View {
        List {
            ForEach(viewModel.tripData?.bookings ?? []) { booking in
                Section {
                    makePickupView(booking: booking)
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 0) // Adjust spacing between sections
                }
                .listRowSeparator(.hidden)
            }.onAppear {
                viewModel.onAppear()
            }.onDisappear {
                viewModel.stopTimer()
            }
            .navigationTitle("Pickup Passengers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
        }.safeAreaInset(edge: .bottom) {
            startTripView()
        }.ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    func startTripView() -> some View {
        if viewModel.tripData?.status == .PickupStarted {
            VStack {
                HStack {
                    PrimaryGreenButton(title: "Start Trip") {
                        viewModel.startTrip()
                    }

                }.padding()

            }.background(Color("TitleColor"))
                .frame(height: 130)
        } else if viewModel.tripData?.status == .IN_PROGRESS {
            VStack {
                HStack {
                    PrimaryGreenButton(title: "End Trip") {
                        viewModel.endTrip()
                    }

                }.padding()

            }.background(Color("TitleColor"))
                .frame(height: 130)
        }
    }

    @ViewBuilder
    func makePickupView(booking: Booking) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            statusView(status: booking.pickupStatus?.passengerStatus)
            if let user = booking.user {
                passendgerView(user: user)
                    .padding(.vertical)
            }
            if let location = booking.pickupLocation {
                pickUpLocationTextView(location)
            }
            if booking.pickupStatus?.passengerStatus != .DriverPickedup {
                VStack {
                    HStack {
                        SecondaryBookingButton(title: "Not Showed up") {
                            viewModel.updatePickupStatus(booking: booking, status: .PassengerNotShowedup)
                        }

                        Spacer()
                        PrimaryGreenButton(title: "Marked as Pickup") {
                            viewModel.updatePickupStatus(booking: booking, status: .PassengerPickedup)
                        }
                    }

                    PrimaryGreenButton(title: "Notify passenger to get ready") {
                        viewModel.updatePickupStatus(booking: booking, status: .PassengerNotified)
                    }
                }
            }

        }.padding(10)
    }

    @ViewBuilder
    func pickUpLocationTextView(_ location: PickupLocation) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image("ic_location_where_to")
                    .resizable()
                    .frame(width: 15, height: 20)
                TextViewLableText(text: "Pickup location")
                Spacer()
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(location.address ?? "Not Provided")
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(UIColor.darkGray))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
                Button {
                    viewModel.openMapButtonPressed(location: location)
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(.darkGray))
                            .frame(width: 35, height: 35)

                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }
                }
            }.frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    func passendgerView(user: User) -> some View {
        UserInfoCardView(viewModel: UserInfoCardViewModel(user: user, showUserContact: true))
    }

    @ViewBuilder
    func statusView(status: PickUpPassengersStatus?) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            let (image, status, statusDetails) = Utils.checkPickUpStatus(isDriver: true, status: status)
            HStack {
                image
                Text(status)
                Spacer()
            }
            Text(statusDetails)
                .foregroundColor(.gray)
                .font(.footnote)
        }
    }
}

// #Preview {
//    PickupPassengersView()
// }
