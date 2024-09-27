//
//  TripCardView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI
struct TripCardView: View {
    @ObservedObject var viewModel: TripCardViewModel
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            VStack(alignment: .leading, spacing: 10) {
                availableSeatsView()
                driverCarView()
                tripRouteView()
            }
            .background(Color.white)
            .cornerRadius(10)
            HStack {
                Text( "€\(String(format: "%.1f", viewModel.trip.pricePerPerson))")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                Text("/Person")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                
            }.padding()
            
        }
        .background(Color("TitleColor"))
        .shadow(radius: 10)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    func availableSeatsView() -> some View {
        HStack {
            Spacer()
            Text("\(viewModel.trip.availableSeats) Seats Available")
                .font(.footnote)
                .foregroundStyle(.darkBlue)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
            Image("ic_heart")
                .resizable()
                .frame(width: 25, height: 25)
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
    let tripResponse = MockDate.getTripsResponse()!
    TripCardView(viewModel: TripCardViewModel(trip: tripResponse.data!.first!))
}
