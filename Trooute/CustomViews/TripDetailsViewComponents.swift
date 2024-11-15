//
//  TripDetailsViewComponents.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-30.
//
import SDWebImageSwiftUI
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
            .cornerRadius(15)
    }
}

struct PickupLocationView: View {
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
                TextViewLableText(text: pickupLication.address ?? String(localized:"Not provided"), textFont: .body)
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
    static func passengersView(passengers: [Passenger], action: @escaping (String) -> Void) -> some View {
        let columns = [
            GridItem(.adaptive(minimum: 40)),
        ]

        VStack(alignment: .leading, spacing: 5) {
            HStack {
                if passengers.isEmpty {
                    Text("Passengers not available")
                        .foregroundColor(.gray)
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(passengers, id: \.id) { passenger in
                            WebImage(url: URL(string: getUrl(passenger: passenger))) { image in
                                image.resizable()
                            } placeholder: {
                                Image("profile_place_holder")
                                    .resizable()
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .padding(1)
                            .onTapGesture {
                                action(passenger.id)
                            }
                        }
                    }
                }
            }
            Divider()

            HStack {
                Text("You might share the ride with fellow passengers heading the same way")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
        }.frame(height: passengers.count == 0 ? 70 : 110)
    }

    static func getUrl(passenger: Passenger) -> String {
        var imageUrl = "\(Constants.baseImageUrl)"
        if let photo = passenger.photo {
            imageUrl = "\(Constants.baseImageUrl)/\(photo)"
        }
        return imageUrl
    }
}
