
//
//  BookingCardView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI
struct BookingCardView: View {
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    @ObservedObject var viewModel: BookingCardViewModel
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            VStack(alignment: .leading, spacing: 10) {
                userBookingInfo()
                if (viewModel.getDriverMode()) {
                    userInfoView()
                } else {
                    driverCarView()
                }
                tripRouteView()
            }
            .background(Color.white)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                if (viewModel.getDriverMode()) {
                    HStack {
                        Text("\(viewModel.booking.numberOfSeats ?? 10000) x Seats")
                            .foregroundStyle(.white)
                        Spacer()
                        Text(viewModel.bookPrice(viewModel.getDriverMode()))
                            .foregroundStyle(.white)
                        
                    }.padding(.horizontal)
                        .padding(.vertical,5)
                    
                    HStack {
                    }.frame(height: 1)
                    .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .padding(.horizontal)
                   
                    
                    
                }
                PriceView(price:  viewModel.finalPrice(viewModel.getDriverMode()), bookingSeats: nil, showPersonText: false)
            }
           
            
        }
        .background(Color("TitleColor"))
        .shadow(radius: 10)
        .cornerRadius(15)
        .onAppear{
            viewModel.onAppear()
        }
    }
    
    @ViewBuilder
    func userInfoView() -> some View {
        if let user = viewModel.booking.user {
            UserInfoCardView(viewModel: UserInfoCardViewModel(user: user))
        }
    }
    
    @ViewBuilder
    func userBookingInfo() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                let driverStatus = user?.driverMode ?? false
                let (image, status) = viewModel.getStatu(driverStatus)
                image
                Text(status)
            }
            HStack {
                TextViewLableText(text: viewModel.bookingId)
            }
            
            HStack {
                Text(viewModel.departureDate)
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
            
        }.padding(.horizontal)
            .padding(.top, 10)
    }
    
    @ViewBuilder
    func driverCarView() -> some View {
        if let driver = viewModel.booking.trip.driver {
            DriverCarView(viewModel: DriverCarViewModel(driver: driver))
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func circleWithDottedLines() -> some View {
        VStack {
            Image("ic_location_from")
                .frame(width: 12, height: 12)
                .padding(.top, 5)

            // Dotted Line
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                .frame(height: 65)

            Image("ic_location_where_to")
                .frame(width: 12, height: 12)
        }.frame(width: 30)
        
    }
    
    @ViewBuilder
    func tripRouteView() -> some View {
        TripRouteView(info: viewModel.getTripRouteModel())
            .padding(.horizontal)
    }
}
#Preview {
//    let tripResponse = MockDate.getUserBookingsResponse()!
    let tripResponse = MockDate.getDriverBookingsResponse()!
    BookingCardView(viewModel: BookingCardViewModel(booking: tripResponse.data!.first!))
}
