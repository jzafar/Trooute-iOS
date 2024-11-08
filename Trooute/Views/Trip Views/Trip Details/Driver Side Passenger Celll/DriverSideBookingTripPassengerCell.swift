//
//  DriverSideBookingTripPassengerCell.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

import SwiftUI

struct DriverSideBookingTripPassengerCell: View {
    var viewModel: DriverSideBookingTripPassengerCellModel
    @ObservedObject var userModel = UserUtils.shared
    var body: some View {
        VStack (alignment: .leading){
            VStack(alignment: .leading, spacing: 10) {
                bookingStatusView()
                if let user = viewModel.booking.user {
                    UserInfoCardView(viewModel: viewModel.getDriverModel(user: user))
                        .padding(.horizontal)
                }
                if viewModel.isHistory && viewModel.booking.user?.id != userModel.user?.id {
                    WriteReviewView(viewModel: WriteReviewViewModel(tripData: viewModel.tripData))
                        .padding(.horizontal)
                }
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                HStack {
                    Text("\(viewModel.booking.numberOfSeats) x Seats")
                        .foregroundStyle(.white)
                    Spacer()
                    Text(viewModel.bookPrice())
                        .foregroundStyle(.white)
                    
                }.padding(.horizontal)
                    .padding(.vertical,5)
                
                HStack {
                }.frame(height: 1)
                .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .padding(.horizontal)
                
                PriceView(price:  viewModel.finalPrice(), bookingSeats: nil, showPersonText: false)
            }
           
            
        }
        .background(Color("TitleColor"))
        .shadow(radius: 10)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    func bookingStatusView() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                statusView()
            }
        }
    }

    @ViewBuilder
    func statusView() -> some View {
        VStack(alignment: .leading) {
            if !viewModel.isHistory {
                let (image, status) = Utils.checkStatus(isDriverApproved: userModel.driverMode, status: viewModel.booking.status)
                HStack {
                    image
                    Text(status)
                }.padding(.bottom, 10)
            }
            
            HStack {
                TextViewLableText(text: viewModel.bookingId)
            }
            HStack {
                Text(viewModel.departureDate)
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }.padding()
            .background(.white)
    }
}

//#Preview {
//    DriverSideBookingTripPassengerCell()
//}
