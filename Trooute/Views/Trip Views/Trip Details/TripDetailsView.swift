//
//  TripDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-27.
//

import SwiftUI

struct TripDetailsView: View {
    @StateObject var viewModel: TripDetailsViewModel
    @ObservedObject var userModel = UserUtils.shared
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        VStack {
            List {
                if userModel.driverMode {
                    Section(header: DriverSectionHeader(seats: "\(viewModel.trip?.trip?.availableSeats ?? 0)")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.trip?.bookings ?? []) { booking in
                                    DriverSideBookingTripPassengerCell(viewModel: viewModel.bookingCardVM(booking: booking))
                                        .onTapGesture {
                                            viewModel.bookingId = booking.id
                                            viewModel.openDetailsView = true
                                        }
                                        .frame(width: viewModel.trip?.bookings?.count == 1 ? screenWidth - 50 : screenWidth - 80)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .padding(0)

                    }.listRowInsets(EdgeInsets())
                } else {
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
                }

                if let trip = viewModel.trip {
                    if userModel.driverMode == false {
                        Section(header: PassengersSectionHeader(seats: "\(viewModel.trip?.availableSeats ?? 0)"), content: {
                            TripDetailsViewComponents.passengersView(passengers: viewModel.trip?.passengers ?? []) {
                                passengerId in
                                viewModel.onTapPassenger(id: passengerId)
                            }

                        })
                    }
                    if let destination = viewModel.getDestinationModel(trip: trip) {
                        Section(header: TextViewLableText(text: "Destination and schedule", textFont: .headline)) {
                            DestinationView(destination: destination, price: userModel.driverMode ? trip.trip?.pricePerPerson ?? 0.0 : trip.pricePerPerson ?? 0.0)
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
            }
            .safeAreaInset(edge: .bottom) {
                if userModel.driverMode {
                    if let trip = viewModel.trip?.trip {
                        pickUpPassengers(trip)
                    }
                } else {
                    if let trip = viewModel.trip {
                        bookNowView(trip)
                        
                    }
                }
            }
        }
        
        .navigationDestination(isPresented: $viewModel.openDetailsView, destination: {
            if let bookingId = viewModel.bookingId {
                BookingDetailsView(viewModel: BookingDetailsViewModel(bookingId: bookingId))
            }
            
        }).navigationDestination(isPresented: $viewModel.showPickUpPassengers, destination: {
            PickupPassengersView(viewModel: PickupPassengersViewModel(tripId: viewModel.tripId))
        })
        .fullScreenCover(item: $viewModel.passgenerId) {
            viewModel.passgenerId = nil
        } content: { id in
            ReviewView(viewModel: ReviewViewModel(userId: id))
        }
        .onAppear {
            viewModel.onApplear()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text("Are you sure you want to cancel this trip. If you'll cancel this trip, your confirmed bookings will be refunded as well."),
                primaryButton: .default(Text("OK"), action: {
                    viewModel.cancelTrip()
            }),
            secondaryButton: .cancel(Text("Cancel")))
        }
    }

    @ViewBuilder
    func pickUpPassengers(_ trip: Trip) -> some View {
        if trip.status == .IN_PROGRESS {
            VStack {
                HStack {
                    PrimaryGreenButton(title: "End Trip") {
                        viewModel.endTrip()
                    }

                }.padding(.horizontal)
                    .padding(.top, 20)

            }.background(Color("TitleColor").ignoresSafeArea(edges: .bottom))
                
                
            
        } else if trip.status == .SCHEDULED ||  trip.status == .PickupStarted {
            VStack {
                HStack {
                    WhiteBorderButton(title: "Cancel") {
                        viewModel.showAlert = true
                    }

                    PrimaryGreenButton(title: "Pickup Passengers") {
                        viewModel.pickUpPassengersPressed()
                    }

                }.padding(.horizontal)
                    .padding(.top, 20)
                

            }.background(Color("TitleColor").ignoresSafeArea(edges: .bottom))
                
        }
        
    }

    @ViewBuilder
    func bookNowView(_ trip: TripsData) -> some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.addToWishList()
                }) {
                    Image("ic_heart")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.horizontal)
                        .foregroundColor(viewModel.trip?.isAddedInWishList ?? false ? .red : .white)
                }

                NavigationLink(destination: BookTripView(viewModel: BookTripViewModel(trip: trip))) {
                    PrimaryGreenText(title: "Book now")
                        .padding(.horizontal)
                }

            }.padding(.horizontal)
                .padding(.top, 20)
        }.background(Color("TitleColor").ignoresSafeArea(edges: .bottom))
            
    }
}

//#Preview {
//    let data = MockDate.getTripsResponse()?.data?.first
//    TripDetailsView(viewModel: TripDetailsViewModel(tripId: data!.id ?? ""))
//}

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

struct DriverSectionHeader: View {
    let title: String = "Passengers"
    let seats: String

    var body: some View {
        HStack {
            TextViewLableText(text: title, textFont: .headline)
            Spacer()
            Text("\(seats) Seats Left")
                .font(.footnote)
                .foregroundStyle(.darkBlue)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
        }.padding(.bottom, 10)
    }
}
