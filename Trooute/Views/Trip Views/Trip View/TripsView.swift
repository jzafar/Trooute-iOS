//
//  TripsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SDWebImageSwiftUI
import SwiftUI

struct TripsView: View {
    @StateObject var viewModel = TripsViewModel()
    @Binding var path: NavigationPath
    @ObservedObject var userModel: UserUtils = UserUtils.shared
    var body: some View {
        List {
            if userModel.driverMode == true {
                if viewModel.trips.count == 0 {
                    noOnGoingTrips()
                } else {
                    ForEach(viewModel.trips) { trip in
//                        Section {
                        Button(action: {
                            path.append(trip.id)
                        }, label: {
                            DriverTripCell(trip: trip)
                        }).buttonStyle(PlainButtonStyle())

                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }

            } else {
                Section {
                    searchTripView()
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }

                Section(header: Text("Trips around you")) {
                    if viewModel.trips.count == 0 {
                        noTripAroundYou()
                    } else {
                        ForEach(viewModel.trips) { trip in
                            Button(action: {
                                path.append(trip.id)
                            }, label: {
                                TripCardView(viewModel: TripCardViewModel(trip: trip))
                            }).buttonStyle(PlainButtonStyle())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                }
            }

        }.listStyle(GroupedListStyle())
            .navigationBarTitle(userModel.driverMode == true ? "Ongoing Trips" : "")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    naivgationUserImageView()
                }
            }
            .onAppear {
                viewModel.onAppear()
            }.onChange(of: viewModel.fromAddressInfo) { fromInfo in
                if fromInfo == nil {
                    if viewModel.fromLocation.count != 0 {
                        viewModel.showErrorAlert()
                    }
                }
            }
            .onChange(of: viewModel.whereToAddressInfo) { whereInfo in
                if whereInfo == nil {
                    if viewModel.toLocation.count != 0 {
                        viewModel.showErrorAlert()
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSearchTrips) {
                viewModel.onAppear()
            } content: {
                SearchResults(viewModel: SearchResultsViewModel(trips: viewModel.searchTripsResult))
            }
            .navigationDestination(for: String.self) { tripId in
                TripDetailsView(viewModel: TripDetailsViewModel(tripId: tripId))
            }
    }

    @ViewBuilder
    func naivgationUserImageView() -> some View {
        HStack {
            WebImage(url: URL(string: viewModel.getUserImage(userModel.user?.photo))) { image in
                image.resizable()
            } placeholder: {
                Image("profile_place_holder")
                    .resizable()
            }

            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .frame(width: 30, height: 30)
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
            .padding(1)

            TextViewLableText(text: "\(userModel.user?.name ?? "")", textFont: .title3)
        }
    }

    @ViewBuilder
    func noOnGoingTrips() -> some View {
        HStack {
            Spacer()
            Text("You don't have any ongoing trip")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.vertical)
            Spacer()
        }.listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }

    @ViewBuilder
    func noTripAroundYou() -> some View {
        HStack {
            Spacer()
            Text("No trip available around you")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.vertical)
            Spacer()
        }.listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }

    @ViewBuilder
    func searchTripView() -> some View {
        VStack(spacing: 20) {
            // From and To Fields
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    // Custom Dotted Line and From Pin
                    circleWithDottedLines()
                    fromWhereToView()
                }
                flexibleDaysView()
                seekOutTripsButton()
            }.padding()
        }.background(.white)
            .cornerRadius(15)
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
                .frame(height: 125)

            Image("ic_location_where_to")
                .frame(width: 12, height: 12)
        }.frame(width: 30)
    }

    @ViewBuilder
    func fromWhereToView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // "From" TextField
            VStack(alignment: .leading, spacing: 4) {
                TextViewLableText(text: String(localized:"From"), textFont: .headline)
                TextField("Enter starting location", text: $viewModel.fromLocation)
                    .googlePlacesAutocomplete($viewModel.fromLocation, placeInfo: $viewModel.fromAddressInfo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                TextViewLableText(text: String(localized:"Distance within (Km)"), textFont: .subheadline)
                ZStack {
                    // Floating Distance for 'From' Slider
                    if viewModel.showFloatingDistanceForFrom {
                        VStack(spacing: 0) {
                            Text(String(format: "%.0f Km", viewModel.distanceFrom))
                                .padding(6)
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)

                            InvertedTriangle()
                                .fill(Color.green)
                                .frame(width: 20, height: 10)
                        }
                        .offset(x: CGFloat((viewModel.distanceFrom) / 70) * (UIScreen.main.bounds.width * 0.65) - UIScreen.main.bounds.width / 2 + 70, y: -35)
                        .animation(.easeInOut, value: viewModel.distanceFrom)
                    }

                    Slider(value: $viewModel.distanceFrom, in: 2 ... 70, step: 1, onEditingChanged: { editing in
                        if editing {
                            withAnimation {
                                viewModel.showFloatingDistanceForFrom = true
                            }
                        } else {
                            withAnimation {
                                viewModel.showFloatingDistanceForFrom = false
                            }
                        }
                    })
                    .accentColor(.primaryGreen)
                }
            }
            // "Where to" TextField
            VStack(alignment: .leading, spacing: 4) {
                TextViewLableText(text: String(localized:"Where to"), textFont: .headline)
                TextField("Enter destination location", text: $viewModel.toLocation)
                    .googlePlacesAutocomplete($viewModel.toLocation, placeInfo: $viewModel.whereToAddressInfo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                // Distance Slider (To)
                TextViewLableText(text: String(localized:"Distance within (Km)"), textFont: .subheadline)

                ZStack {
                    // Floating Distance for 'To' Slider
                    if viewModel.showFloatingDistanceForTo {
                        VStack(spacing: 0) {
                            Text(String(format: "%.0f Km", viewModel.distanceTo))
                                .padding(6)
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)

                            InvertedTriangle()
                                .fill(Color.green)
                                .frame(width: 20, height: 10)
                        }
                        .offset(x: CGFloat((viewModel.distanceTo) / 70) * (UIScreen.main.bounds.width * 0.65) - UIScreen.main.bounds.width / 2 + 70, y: -35)
                        .animation(.easeInOut, value: viewModel.distanceTo) // Using iOS 15 animation modifier
                    }

                    Slider(value: $viewModel.distanceTo, in: 2 ... 70, step: 1, onEditingChanged: { editing in
                        if editing {
                            withAnimation {
                                viewModel.showFloatingDistanceForTo = true
                            }
                        } else {
                            withAnimation {
                                viewModel.showFloatingDistanceForTo = false
                            }
                        }
                    })
                    .accentColor(.primaryGreen) // Changes the slider knob and track to green color
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                chooseTripDate()
            }
//            VStack(alignment: .leading, spacing: 4) {
//                flexibleDaysView()
//            }
        }
    }

    @ViewBuilder
    func chooseTripDate() -> some View {
        // Date section
        TextViewLableText(text: String(localized:"Choose the date of the trip"), textFont: .headline)
        Button(action: {
            viewModel.isDatePickerPresented.toggle()
        }) {
            HStack {
                if let selectedDate = viewModel.date {
                    Text(selectedDate.mediumFormatDate())
                } else {
                    Text("Choose Date")
                }
                Spacer()
                Image(systemName: "calendar")
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $viewModel.isDatePickerPresented) {
                showDatePicker()
            }
    }

    @ViewBuilder
    func showDatePicker() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button("Done") {
                    viewModel.date = viewModel.date == nil ? Date() : viewModel.date
                    viewModel.isDatePickerPresented = false
                }.padding(.horizontal)
                    .buttonStyle(PlainButtonStyle())
            }
            DatePicker(
                "Choose Date",
                selection: Binding(
                    get: { viewModel.date ?? Date() },
                    set: { newDate in
                        viewModel.date = newDate
                    }
                ),
                in: Date()..., // Prevent selecting past dates
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .presentationDetents([.medium])
        }
    }

    @ViewBuilder
    func flexibleDaysView() -> some View {
        HStack {
            Toggle(isOn: $viewModel.isFlexibleDate) {
                Text("My dates are flexible")
            }
            .toggleStyle(CheckboxStyle())

            Spacer()
            Image(systemName: "minus.circle")
                .font(.title)
                .foregroundStyle(viewModel.isFlexibleDate ? .primaryGreen : .primaryGreen.opacity(0.5))
                .onTapGesture {
                    if viewModel.flexibleDays > 1 {
                        viewModel.flexibleDays -= 1
                    }
                }.allowsHitTesting(viewModel.isFlexibleDate ? true : false)

            Text("\(viewModel.flexibleDays)")
                .padding(.horizontal)
                .font(.title)
                .padding(.horizontal, -15)
                .foregroundStyle(viewModel.isFlexibleDate ? Color.black : Color.gray)

            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundStyle(viewModel.isFlexibleDate ? .primaryGreen : .primaryGreen.opacity(0.5))
                .onTapGesture {
                    viewModel.flexibleDays += 1
                }.allowsHitTesting(viewModel.isFlexibleDate ? true : false)

        }.padding(.top, 10)
    }

    @ViewBuilder
    func seekOutTripsButton() -> some View {
        PrimaryGreenButton(title: String(localized:"Seek Out Trips")) {
            viewModel.seekOutTrip()
        }.padding(.vertical)
    }
}

// #Preview {
//    TripsView()
// }
