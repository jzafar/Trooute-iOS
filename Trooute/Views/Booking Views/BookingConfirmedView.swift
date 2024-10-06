//
//  BookingConfirmedView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-04.
//

import SwiftUI

struct BookingConfirmedView: View {

    let trip: TripsData
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Image at the top
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green) // Replace with the actual image
                    
                    // Text Section
                    VStack(spacing: 8) {
                        Text("Trip Booking Request Sent")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Text("Thank you for choosing our ride-sharing platform!\nYour booking request for the upcoming trip has been successfully sent.We’ll notify you as soon as your booking is confirmed.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 16)
                    
                    TripCardView(viewModel: TripCardViewModel(trip: trip, bookingSeats: trip.availableSeats))
                    
                    
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 16)
            
            .safeAreaInset(edge: .bottom) {
                PrimaryGreenButton(title: "Back to home") {
                    NavigationUtil.popToRootView()
                }.padding(.horizontal)
                    .padding(.top, 5)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
    }
}



struct BookingConfirmedView_Previews: PreviewProvider {
    static var previews: some View {
        let tripResponse = MockDate.getTripsResponse()!
        BookingConfirmedView(trip: tripResponse.data!.first!)
    }
}

