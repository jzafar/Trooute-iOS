//
//  BookingDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import SwiftUI

struct BookingDetailsView: View {
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @StateObject var viewModel: BookingDetailsViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let driverMode = user?.driverMode ?? false
            List {
                Section(header: TextViewLableText(text: "Booking Detail")) {
                    bookingStatusView()
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                }

                if driverMode {
                    Section(header: TextViewLableText(text: "Passengers Details")) {
                        passengerInfoView()
                            .listRowBackground(Color.white)
                    }

                } else {
                    Section(header: TextViewLableText(text: "Driver Details")) {
                        driverDetails()
                            .listRowBackground(Color.white)
                    }

                    Section {
                        carInfoView()
                            .listRowBackground(Color.white)
                    }

                    Section(header: PassengersSectionHeader(seats: viewModel.availableSeats), content: {
                        TripDetailsViewComponents.passengersView(passengers: viewModel.bookingData?.trip.passengers ?? [])
                    })

                    if let des = viewModel.getDestinationModel() {
                        Section(header: TextViewLableText(text: "Destination and schedule", textFont: .headline))
                            {
                                DestinationView(destination: des, price: viewModel.bookingData?.trip.pricePerPerson ?? 0.0)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                            }
                    }

                    Section(header: TextViewLableText(text: "Trip Details")) {
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

                if let pickupLocation = viewModel.bookingData?.pickupLocation {
                    Section(header: TextViewLableText(text: "Pickup location")) {
                        PickupLocationView(pickupLication: pickupLocation, otherReleventDetails: viewModel.bookingData?.note)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                    }
                }
            }.onAppear {
                Tabbar.shared.hide = true
                viewModel.getBookingDetails()
            }.onChange(of: viewModel.popView) { newVal in
                if newVal == true {
                }
            }

        }.navigationTitle("Booking Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .sheet(isPresented: $viewModel.showPaymentsScreen) {
                WebView(webViewModel: viewModel.getWebViewModel())
            }
    }

    @ViewBuilder
    func driverDetails() -> some View {
        userInfoView()
    }

    @ViewBuilder
    func userInfoView() -> some View {
        if let user = viewModel.bookingData?.trip.driver {
            UserInfoCardView(viewModel: UserInfoCardViewModel(user: user))
        }
    }

    @ViewBuilder
    func passengerInfoView() -> some View {
        if let user = viewModel.bookingData?.user {
            UserInfoCardView(viewModel: UserInfoCardViewModel(user: user))
        }
    }

    @ViewBuilder
    func carInfoView() -> some View {
        if let carDetails = viewModel.bookingData?.trip.driver?.carDetails {
            CarInfoView(viewModel: CarInfoViewModel(carDetails: carDetails))
        }
    }

    @ViewBuilder
    func bookingStatusView() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                statusView()
                priceView()
            }
        }
        .background(Color("TitleColor"))
        .cornerRadius(15)
    }

    @ViewBuilder
    func priceView() -> some View {
        PriceView1(finalPrice: viewModel.finalPrice(viewModel.getDriverMode()),
                   bookingSeats: viewModel.bookingData?.numberOfSeats,
                   bookingSeatsPrice: viewModel.bookPrice(),
                   showPersonText: false,
                   showSeatsRow: true,
                   showPlateformFee: true)
    }

    @ViewBuilder
    func statusView() -> some View {
        VStack(alignment: .leading) {
            let driverStatus = user?.driverMode ?? false
            let (image, status) = Utils.checkStatus(isDriverApproved: driverStatus, status: viewModel.bookingData?.status ?? .none)
            HStack {
                image
                Text(status)
            }
            HStack {
                Text(viewModel.getStatusText(isDriver: driverStatus, status: viewModel.status))
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }.padding(.bottom, 10)
            HStack {
                TextViewLableText(text: viewModel.bookingID ?? "")
            }
            HStack {
                Text(viewModel.departureDate)
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }

            HStack {
                if driverStatus {
                    if viewModel.bookingData?.status == .waiting {
                        SecondaryBookingButton(title: "Cancel booking") {
                            viewModel.cancelBooking()
                        }

                        PrimaryGreenButton(title: "Accept") {
                        }
                    } else if viewModel.bookingData?.status == .approved {
                        Spacer()
                        SecondaryBookingButton(title: "Cancel booking") {
                        }
                    }
                } else {
                    if viewModel.bookingData?.status == .waiting {
                        Spacer()
                        SecondaryBookingButton(title: "Cancel booking") {
                        }
                    } else if viewModel.bookingData?.status == .approved {
                        SecondaryBookingButton(title: "Cancel booking") {
                        }
                        PrimaryGreenButton(title: "Make Payment") {
                            viewModel.makePayments()
                        }
                    }
                }
            }
        }.padding()
            .background(.white)
            .cornerRadius(15)
    }
}

#Preview {
    BookingDetailsView(viewModel: BookingDetailsViewModel(bookingId: "132"))
}
