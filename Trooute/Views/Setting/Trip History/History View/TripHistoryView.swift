//
//  TripHistory.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-03.
//

import SwiftUI

struct TripHistoryView: View {
    @StateObject var viewModel = TripHistoryViewModel()
    var body: some View {
        VStack {
            if viewModel.trips.count == 0 {
                HStack {
                    Spacer()
                    Text("You don't have any trip")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.vertical)
                    Spacer()
                }.listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                List {
                    ForEach(viewModel.trips) { trip in
                        ZStack {
                            NavigationLink(destination: HistoryDetailsView(viewModel: HistoryDetailsViewModel(tripId: trip.id))) {
                                EmptyView()
                            }.opacity(0)
                            histroyCell(trip: trip)
                        }.listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
        .onAppear {
            Tabbar.shared.hide = true
            viewModel.onAppear()
        }
        .navigationTitle("Trip History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
    }
    
    @ViewBuilder
    func histroyCell(trip: TripsData) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                TextViewLableText(text: "Trip # \(trip.id.firstTenCharacters())")
                    .padding(.horizontal)
                    .padding(.top)
                Text(trip.departureDate?.fullFormate() ?? "")
                    .foregroundStyle(.gray)
                    .font(.callout)
                    .padding(.horizontal)
                passengersView(trip.passengers ?? [])
                    .padding(.horizontal)
                if let fromAddress = trip.fromAddress,
                   let whereTo = trip.whereToAddress,
                   let date = trip.departureDate {
                    tripRouteView(fromAddress, whereToAddress: whereTo, date: date)
                        .padding(.horizontal)
                }
            }.background(.white)
                .cornerRadius(15)
            priceView(trip.pricePerPerson ?? 0.0, totaol: trip.totalAmount ?? 0.0)
        }.background(Color("TitleColor"))
            .cornerRadius(15)
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
            
        }
    }
    
    @ViewBuilder
    func tripRouteView(_ fromAddress: String, whereToAddress: String, date: String) -> some View {
        TripRouteView(info: TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: date))
    }
    
    @ViewBuilder
    func priceView(_ price: Double, totaol: Double) -> some View {
        PriceView1(finalPrice: price, bookingSeats: nil, bookingSeatsPrice: nil, showPersonText: true, showSeatsRow: false, showPlateformFee: false, showTotal: true, totalPrice: totaol)
    }
}

//#Preview {
//    TripHistory()
//}
