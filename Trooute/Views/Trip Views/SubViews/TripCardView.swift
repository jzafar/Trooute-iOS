//
//  TripCardView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI
struct TripCardView: View {
    @StateObject var viewModel: TripCardViewModel
    @ObservedObject var userModel: UserUtils = UserUtils.shared
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            VStack(alignment: .leading, spacing: 10) {
                availableSeatsView()
                driverCarView()
                if let vm = viewModel.getTripRouteModel() {
                    tripRouteView(vm: vm)
                }
               
            }
            .background(Color.white)
            .cornerRadius(10)
            VStack(alignment: .leading) {
                if let seats = viewModel.bookingSeats {
                    HStack {
                        Text("\(seats) x Seats")
                            .foregroundStyle(.white)
                        Spacer()
                        Text(viewModel.bookPrice)
                            .foregroundStyle(.white)
                        
                    }.padding(.horizontal)
                        .padding(.vertical,5)
                    
                    HStack {
                        Text("Platform fee")
                            .foregroundStyle(.white)
                        Spacer()
                        Text("€\(seats).0")
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
                PriceView(price: viewModel.finalPrice, bookingSeats: viewModel.bookingSeats, showPersonText: viewModel.showPersonText)
            }
           
            
        }
        .background(Color("TitleColor"))
        .shadow(radius: 10)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    func availableSeatsView() -> some View {
        HStack {
            Spacer()
            Text("\(viewModel.trip.availableSeats ?? 0) Seats Available")
                .font(.footnote)
                .foregroundStyle(.darkBlue)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
                Image("ic_heart")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor((viewModel.trip.isAddedInWishList ?? false) ? .red : .black)
                    .onTapGesture {
                        viewModel.addToWishList()
                    }
        }.padding(.horizontal)
            .padding(.top)
    }
    
    @ViewBuilder
    func driverCarView() -> some View {
        if let driver = viewModel.trip.driver {
            DriverCarView(viewModel: DriverCarViewModel(driver: driver))
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func tripRouteView(vm: TripRouteModel) -> some View {
        TripRouteView(info: vm)
            .padding(.horizontal)
    }
}
//#Preview {
//    let tripResponse = MockDate.getTripsResponse()!
//    TripCardView(viewModel: TripCardViewModel(trip: tripResponse.data!.first!, bookingSeats: 2, showPersonText: true))
//}
