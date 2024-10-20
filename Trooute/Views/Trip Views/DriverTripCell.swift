//
//  DriverTripsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//

import SwiftUI
import SDWebImageSwiftUI

struct DriverTripCell: View {
    var trip: TripInfo
    @ObservedObject var userModel: UserUtils = UserUtils.shared
    var body: some View {
        wishCell(wish: trip)
    }
    
    @ViewBuilder
    func wishCell(wish: TripInfo) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .trailing) {
                    HStack {
                        availableSeatsView(Int(wish.availableSeats ?? 0))
                    }
                }
                passengersView(wish.passengers ?? [])
                if let fromAddress = wish.from_address,
                   let whereTo = wish.whereTo_address,
                   let date = wish.departureDate {
                    tripRouteView(fromAddress, whereToAddress: whereTo, date: date)
                }
            }.background(.white)
                .cornerRadius(15)
            priceView(wish.pricePerPerson ?? 0.0)
        }.background(Color("TitleColor"))
            .cornerRadius(15)
    }
    
    @ViewBuilder
    func priceView(_ price: Double) -> some View {
        PriceView1(finalPrice: price, bookingSeats: nil, bookingSeatsPrice: nil, showPersonText: true, showSeatsRow: false, showPlateformFee: false)
    }
    
    @ViewBuilder
    func tripRouteView(_ fromAddress: String, whereToAddress: String, date: String) -> some View {
        TripRouteView(info: TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: date))
            .padding(.horizontal)
    }
    
    @ViewBuilder
    func passengersView(_ passengers: [Passenger]) -> some View {
        VStack (alignment: .leading) {
            Text("Passengers")
                .foregroundStyle(Color("TitleColor"))
            if passengers.count > 0 {
                HorizontalCollectionView(items: passengers)
            } else {
                Text("Passengers not available")
                    .foregroundStyle(.gray)
            }
            
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func availableSeatsView(_ numberOfSeat: Int) -> some View {
        HStack {
            Spacer()
            Text("\(numberOfSeat) Seats \(userModel.driverMode ? "Left" : "Available")")
                .font(.footnote)
                .foregroundStyle(.darkBlue)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
            if !userModel.driverMode {
                Image("ic_heart")
                    .resizable()
                    .foregroundStyle(trip.isAddedInWishList == true ? .red : .black)
                    .frame(width: 25, height: 25)
            }
            
        }.padding(.horizontal)
            .padding(.top, 10)
    }
}
struct HorizontalCollectionView: View {
    let items: [Passenger]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {  // Horizontal scrolling
            LazyHStack(spacing: 5) {  // LazyHStack to optimize loading
                ForEach(items) { item in
                    VStack {
                        WebImage(url: URL(string: "\(Constants.baseImageUrl)/\(item.photo ?? "")")) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle")
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                        .padding(1)
                       
                    }
                    .frame(width: 60, height: 60)
                }
            }
        }
    }
}
