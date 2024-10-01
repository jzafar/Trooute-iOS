//
//  TripDetailsViewComponents.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-30.
//
import SwiftUI

struct DestinationView: View {
    @State var destination: TripRouteModel
    @State var price: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading, spacing: 10) {
                TripRouteView(info: destination)
                    .padding(.top)
            }
            .background(Color.white)
            .cornerRadius(10)
            PriceView(price: price, bookingSeats: nil, showPersonText: true)
        }
        .background(Color("TitleColor"))
        .shadow(radius: 10)
        .cornerRadius(15)
    }
}

struct TripPrefView: View {
    @State var handCarryWeight: String
    @State var suitcaseWeight: String
    @State var smokingPreference: String
    @State var petPreference: String
    @State var languagePreference: String
    @State var otherReliventDetails: String
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Restrictions on luggage type and weight")
                .foregroundStyle(.gray)
                .padding(.top, 10)
                .padding(.horizontal)
            MasterDetailsView(master: "Type", details: "Hand carry")
            MasterDetailsView(master: "weight", details: handCarryWeight)
            MasterDetailsView(master: "Type", details: "Suitcase")
            MasterDetailsView(master: "weight", details: suitcaseWeight)
            Divider()
                .padding(.horizontal)
            MasterDetailsView(master: "Smoking Allowed", details: smokingPreference)
            MasterDetailsView(master: "Pets Allowed", details: petPreference)
            MasterDetailsView(master: "Language", details: languagePreference)
            Divider()
                .padding(.horizontal)
            Text("Other relevent details")
                .foregroundStyle(.gray)
                .padding(.horizontal)
            Text(otherReliventDetails)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.bottom)
        }.background(.white)
            .cornerRadius(25)
    }
}

struct PickupLocationView : View {
    @State var pickupLication: PickupLocation
    @State var otherReleventDetails: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_location_where_to")
                    .resizable()
                    .frame(width: 10, height: 15)
                Text("From")
                    .foregroundStyle(.gray)
                Spacer()
            }
            HStack {
                TextViewLableText(text: pickupLication.address ?? "Not provided", textFont: .body)
            }
            VStack(alignment: .leading) {
                Text("Other relevent details about trip")
                    .foregroundStyle(.gray)
                Text(otherReleventDetails ?? "Not Provided")
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
            }
        }.padding()
        .background(.white)
            .cornerRadius(25)
    }
}

struct TripDetailsViewComponents {
    @ViewBuilder
    static func passengersView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Passengers not available")
                    .foregroundStyle(.gray)
            }
            Divider()

            HStack {
                Text("You might share the ride with fellow passengers heading the same way")
                    .foregroundStyle(.gray)
            }
        }
    }
}
