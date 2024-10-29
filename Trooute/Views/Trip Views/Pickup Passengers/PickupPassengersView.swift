//
//  PickupPassengersView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-29.
//

import SwiftUI

struct PickupPassengersView: View {
    @ObservedObject var viewModel: PickupPassengersViewModel
    @StateObject var userModel = UserUtils.shared
    var body: some View {
        VStack {
            List {
                Section(header: TextViewLableText(text: "Passengers", textFont: .headline)) {
                    ForEach(viewModel.bookings) { booking in
                        makePickupView(booking: booking)
                            .listRowBackground(Color.white)
                            .listRowInsets(EdgeInsets())
                    }
                }.onAppear {
                    viewModel.onAppear()
                }
                .navigationTitle("Pickup Passengers")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarRole(.editor)
            }.safeAreaInset(edge: .bottom) {
                startTripView()
            }
        }
    }
    @ViewBuilder
    func startTripView() -> some View {
        VStack {
            HStack {
                PrimaryGreenButton(title: "Start Trip") {
                    viewModel.startTrip()
                }

            }.padding(.horizontal)
                .background(Color("TitleColor"))
                .frame(height: 100)
            
        }.background(Color("TitleColor"))
            .frame(height: 130)
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
            
            VStack {
                HStack {
                    SecondaryBookingButton(title: "Not Showed up") {
                        viewModel.notShowedUP()
                    }

                    Spacer()
                    PrimaryGreenButton(title: "Marked as Pickup") {
                        viewModel.markedAsPickup()
                    }
                }
                
                PrimaryGreenButton(title: "Notify passenger to get ready") {
                    viewModel.notifyPassengerToGetReady()
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
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
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
            let (image, status, statusDetails) = Utils.checkPickUpStatus(status: status)
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
