//
//  BookTripView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import SwiftUI

struct BookTripView: View {
    @StateObject var viewModel: BookTripViewModel
    var body: some View {
        VStack {
            List {
                Section {
                    TripCardView(viewModel: TripCardViewModel(trip: viewModel.trip, showPersonText: true)) // user side = true
                }.listRowInsets(EdgeInsets())

                Section(header: TextViewLableText(text: "Pickup location")) {
                    pieckupLocationView()
                        .listRowBackground(Color.white)
                }

                Section(header: TextViewLableText(text: "Passengers")) {
                    passengersView()
                        .listRowBackground(Color.white)
                }
            }.background(.clear)
                .safeAreaInset(edge: .bottom) {
                    proceedView()
                }
        }
        .onChange(of: viewModel.pickUpAddressInfo) { fromInfo in
            if fromInfo == nil {
                viewModel.showErrorAlert()
            }
        }
        .navigationTitle("Booking")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
        .toolbarRole(.editor)
        
    }

    @ViewBuilder
    func pieckupLocationView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            TextViewLableText(text: "Pickup location", textFont: .subheadline)
            TextField("Enter Pickup location", text: $viewModel.pickupLocation)
                .googlePlacesAutocomplete($viewModel.pickupLocation, placeInfo: $viewModel.pickUpAddressInfo)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .font(.body)
                
            TextViewLableText(text: "Other relevent details about trip", textFont: .subheadline)
            ZStack {
                TextEditor(text: $viewModel.otherReleventDetails)
                    .padding(5)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .multilineTextAlignment(.leading)
                    .frame(height: 120)
                if viewModel.otherReleventDetails.isEmpty {
                    VStack {
                        HStack {
                            Text("Please be on time as we have a tight schedule.")
                                .foregroundStyle(.tertiary)
                                .padding(.top, 15)
                                .padding(.leading, 15)

                            Spacer()
                        }

                        Spacer()
                    }
                }
            }
        }.padding(.vertical)
    }

    @ViewBuilder
    func passengersView() -> some View {
        HStack {
            TextViewLableText(text: "Persons", textFont: .headline)
                .bold()
            Spacer()
            HStack {
                HStack {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundStyle(.primaryGreen)
                        .onTapGesture {
                            if viewModel.totalPerson > 1 {
                                viewModel.totalPerson -= 1
                                viewModel.updatePrice()
                            }
                        }

                    Text("\(viewModel.totalPerson)")
                        .padding(.horizontal)
                        .font(.title)
                        .padding(.horizontal, -15)

                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundStyle(.primaryGreen)
                        .onTapGesture {
                            viewModel.updatePassengers()
                        }
                }
            }
                .padding(5)
                .cornerRadius(15)
                .frame(height: 50)
        }
    }
    
    @ViewBuilder
    func proceedView() -> some View {
        VStack {
            HStack {
                Text( "€\(String(format: "%.1f", viewModel.totalPrice))")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                PrimaryGreenButton(title: "Proceed") {
                    viewModel.proceedButtonPressed()
                }.padding(.horizontal)
                    .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                        if let proceedViewModel = viewModel.proceedViewModel {
                            ProceedView(viewModel: proceedViewModel)
                        }
                    }

            }.padding(.horizontal)
                .background(Color("TitleColor"))
                .frame(height: 100)

        }.background(Color("TitleColor"))
            .frame(height: 130)
    }
}

#Preview {
    let data = MockDate.getTripsResponse()?.data?.first
    BookTripView(viewModel: BookTripViewModel(trip: data!))
}
