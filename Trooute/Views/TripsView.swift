//
//  TripsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct TripsView: View {
    @ObservedObject var viewModel = TripsViewModel()
    var body: some View {
        List {
            Section {
                searchTripView()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            Section(header: Text("Trips around you")) {
                if viewModel.nearByTrips.count == 0 {
                    HStack {
                        Spacer()
                        Text("No trip around you")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding(.vertical)
                        Spacer()
                    }.listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.nearByTrips) { trip in
                            ZStack {
                                NavigationLink(destination: TripDetailsView(viewModel: TripDetailsViewModel(trip: trip))) {
                                    EmptyView()
                                    }.opacity(0)
                                TripCardView(viewModel: TripCardViewModel(trip: trip))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }.background(.clear)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                           
                        
                    }
                }
            }

        }.listStyle(GroupedListStyle())
            .onAppear {
                viewModel.fetchTrips()
            }
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
                TextViewLableText(text: "From", textFont: .headline)
                TextField("Enter starting location", text: $viewModel.fromLocation)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                TextViewLableText(text: "Distance within (Km)", textFont: .subheadline)
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
                        .offset(x: CGFloat((viewModel.distanceFrom) / 18) * (UIScreen.main.bounds.width * 0.8) - UIScreen.main.bounds.width / 2 + 20, y: -35)
                        .animation(.easeInOut, value: viewModel.distanceFrom)
                    }

                    Slider(value: $viewModel.distanceFrom, in: 2 ... 20, step: 1, onEditingChanged: { editing in
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
                TextViewLableText(text: "Where to", textFont: .headline)
                TextField("Enter destination location", text: $viewModel.toLocation)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                // Distance Slider (To)
                TextViewLableText(text: "Distance within (Km)", textFont: .subheadline)

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
                        .offset(x: CGFloat((viewModel.distanceTo) / 18) * (UIScreen.main.bounds.width * 0.8) - UIScreen.main.bounds.width / 2 + 20, y: -35)
                        .animation(.easeInOut, value: viewModel.distanceTo) // Using iOS 15 animation modifier
                    }

                    Slider(value: $viewModel.distanceTo, in: 2 ... 20, step: 1, onEditingChanged: { editing in
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
        TextViewLableText(text: "Choose the date of the trip", textFont: .headline)
//            Rectangle()
//                .frame(height: 40)
//                .cornerRadius(10)
//                .overlay {
//                    HStack {
//                        if let selectedDate = viewModel.date {
//                            Text(selectedDate.formatDate())
//                                .foregroundStyle(.blue)
//                        } else {
//                            Text("Choose Date")
//                                .foregroundStyle(.blue)
//                        }
//                        Spacer()
//                        Image(systemName: "calendar")
//                            .foregroundStyle(.blue)
//                    }.onTapGesture {
//                        viewModel.isDatePickerPresented.toggle()
//                    }
//                    .padding()
//                    .background(Color(UIColor.systemGray6))
//                    .cornerRadius(10)
//                }
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
        }
        .sheet(isPresented: $viewModel.isDatePickerPresented) {
            showDatePicker()
        }
    }

    @ViewBuilder
    func showDatePicker() -> some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: Binding(
                    get: { viewModel.date ?? Date() },
                    set: { newDate in
                        viewModel.date = newDate
                        viewModel.isDatePickerPresented = false
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
                .foregroundStyle(.primaryGreen)
                .onTapGesture {
                    if viewModel.flexibleDays > 1 {
                        viewModel.flexibleDays -= 1
                    }
                }

            Text("\(viewModel.flexibleDays)")
                .padding(.horizontal)
                .font(.title)
                .padding(.horizontal, -15)

            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundStyle(.primaryGreen)
                .onTapGesture {
                    viewModel.flexibleDays += 1
                }

        }.padding(.top, 10)
    }

    @ViewBuilder
    func seekOutTripsButton() -> some View {
        PrimaryGreenButton(title: "Seek Out Trips") {
        }.padding(.vertical)
    }
}

#Preview {
    TripsView()
}
