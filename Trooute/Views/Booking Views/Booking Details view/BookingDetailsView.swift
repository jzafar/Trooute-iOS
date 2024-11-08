//
//  BookingDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import SwiftUI

struct BookingDetailsView: View {
    @StateObject var viewModel: BookingDetailsViewModel
    @StateObject var userModel = UserUtils.shared
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            let driverMode = userModel.driverMode
            List {
                if !userModel.driverMode &&
                    viewModel.bookingData?.trip.status == .PickupStarted &&
                    viewModel.bookingData?.status == .confirmed,
                    let booking = viewModel.currentBooking {
                    Section (header: TextViewLableText(text: "Pickup Status")) {
                        pickupStatusView(booking)
                            .listRowBackground(Color.white)
                            .listRowInsets(EdgeInsets())
                    }
                    
                }
                if let _ = viewModel.bookingData {
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
                            TripDetailsViewComponents.passengersView(passengers: viewModel.bookingData?.trip.passengers ?? []) { passengerId in
                                viewModel.onTapPassenger(id: passengerId)
                            }
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
            }.onDisappear {
                viewModel.stopTimerIfRunning()
            }

        }.navigationTitle("Booking Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .sheet(isPresented: $viewModel.showPaymentsScreen) {
                viewModel.getBookingDetails()
            } content: {
                WebView(webViewModel: viewModel.getWebViewModel())
            }
            .fullScreenCover(item: $viewModel.passgenerId) {
                viewModel.getBookingDetails()
            } content: { id in
                ReviewView(viewModel: ReviewViewModel(userId: id))
            }
    }

    @ViewBuilder
    func pickupStatusView(_ booking: Booking) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                pickUpStatusView(booking)
            }
        }
    }

    @ViewBuilder
    func driverDetails() -> some View {
        userInfoView()
    }

    @ViewBuilder
    func userInfoView() -> some View {
        if let user = viewModel.bookingData?.trip.driver {
            UserInfoCardView(viewModel: UserInfoCardViewModel(user: user, showUserContact: viewModel.bookingData?.status == .confirmed))
        }
    }

    @ViewBuilder
    func passengerInfoView() -> some View {
        if let user = viewModel.bookingData?.user {
            UserInfoCardView(viewModel: UserInfoCardViewModel(user: user, showUserContact: viewModel.bookingData?.status == .confirmed))
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
        PriceView1(finalPrice: viewModel.finalPrice,
                   bookingSeats: viewModel.bookingData?.numberOfSeats,
                   bookingSeatsPrice: viewModel.bookPrice(),
                   showPersonText: false,
                   showSeatsRow: true,
                   showPlateformFee: true)
    }

    @ViewBuilder
    func pickUpStatusView(_ booking: Booking) -> some View {
        VStack(alignment: .leading) {
            let isDriver = userModel.driverMode
            if let driverStatus = booking.pickupStatus?.driverStatus {
                let (image, status, details) = Utils.checkPickUpStatus(isDriver: isDriver, status: driverStatus)
                if let passengerStatus = booking.pickupStatus?.passengerStatus,
                     passengerStatus == .DriverPickedup || passengerStatus == .DriverNotShowedup {
                        let (image1, status1, details1) = Utils.checkPickUpStatus(isDriver: isDriver, status: passengerStatus)
                        HStack {
                            image1
                            Text(status1)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        Text(details1)
                    
                } else {
                    HStack {
                        image
                        Text(status)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    Text(details)
                }
            }
            if let passengerStatus = booking.pickupStatus?.passengerStatus,
               passengerStatus == .DriverPickedup  {
            } else {
                HStack {
                    SecondaryBookingButton(title: "Not showed up") {
                        viewModel.updatePickUpStatus(status: .DriverNotShowedup)
                    }

                    Spacer()
                    PrimaryGreenButton(title: "Marked as Pickup") {
                        viewModel.updatePickUpStatus(status: .DriverPickedup)
                    }
                }
            }
            
        }.padding()
        .cornerRadius(15)
    }

    @ViewBuilder
    func statusView() -> some View {
        VStack(alignment: .leading) {
            let driverMode = userModel.driverMode
            let (image, status) = Utils.checkStatus(isDriverApproved: driverMode, status: viewModel.bookingData?.status ?? .none)
            HStack {
                image
                Text(status)
                Spacer()
            }
            HStack {
                Text(viewModel.getStatusText(isDriver: driverMode, status: viewModel.status))
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
                if driverMode {
                    if viewModel.bookingData?.status == .waiting {
                        SecondaryBookingButton(title: "Cancel booking") {
                            viewModel.cancelBooking()
                        }

                        Spacer()
                        PrimaryGreenButton(title: "Accept") {
                            viewModel.acceptBooking()
                        }

                    } else if viewModel.bookingData?.status == .approved ||
                        viewModel.bookingData?.status == .confirmed {
                        Spacer()
                        SecondaryBookingButton(title: "Cancel booking") {
                            viewModel.cancelBooking()
                        }
                    }
                } else {
                    if viewModel.bookingData?.status == .waiting ||
                        viewModel.bookingData?.status == .confirmed {
                        if viewModel.bookingData?.trip.status == .PickupStarted {
                        } else {
                            Spacer()
                            SecondaryBookingButton(title: "Cancel booking") {
                                viewModel.cancelBooking()
                            }
                        }

                    } else if viewModel.bookingData?.status == .approved {
                        SecondaryBookingButton(title: "Cancel booking") {
                            viewModel.cancelBooking()
                        }
                        Spacer()
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

// #Preview {
//    BookingDetailsView(viewModel: BookingDetailsViewModel(bookingId: "132"))
// }
