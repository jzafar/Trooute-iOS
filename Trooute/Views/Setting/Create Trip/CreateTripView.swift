//
//  CreateTripView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import Combine
import SwiftUI
struct CreateTripView: View {
    @StateObject var viewModel = CreateTripViewModel()
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            Section(header: TextViewLableText(text: String(localized:"Destination and schedule"))) {
                destinationAndSchedule()
                    .listRowBackground(Color.white)
            }
            Section(header: TextViewLableText(text: String(localized:"Trip Details"))) {
                tripsDetailsView()
                    .listRowBackground(Color.white)
            }
            
            Section(header: TextViewLableText(text: String(localized:"Acceptable Payments"))){
                choosePaymentsWay()
                    .listRowBackground(Color.white)
            }
            
            Section {
                HStack {
                    PrimaryGreenButton(title: String(localized:"Post trip")) {
                        hideKeyboard()
                        viewModel.postTrip()
                    }.zIndex(1)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

        }
        .navigationTitle("Set up your Trip")
            .toolbar(.hidden, for: .tabBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            
            .onChange(of: viewModel.fromAddressInfo) { fromInfo in
                if fromInfo == nil {
                    viewModel.showErrorAlert()
                }
            }
            .onChange(of: viewModel.whereToAddressInfo) { whereInfo in
                if whereInfo == nil {
                    viewModel.showErrorAlert()
                }
            }.onChange(of: viewModel.dissMissView) { newVal in
                if newVal {
                    dismiss()
                }
            }.onTapGesture {
                hideKeyboard()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                        hideKeyboard()
                    }
                }
            }
    }

    @ViewBuilder
    func choosePaymentsWay() -> some View {
        VStack(spacing: 16) {
            ForEach($viewModel.paymentOptions) { $option in
                ZStack(alignment: .leading) {
                    Toggle(isOn: $option.isOn) {
                        Text(option.type.localizedDdriverString)
                    }
                    .disabled(!option.isEnabled)
                    .opacity(option.isEnabled ? 1 : 0.8)
                    
                    if !option.isEnabled {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.message(type:option.type)
                            }
                    }
                }
                .contentShape(Rectangle())
                .frame(height: 44)
            }
        }
    }
    
    @ViewBuilder
    func tripsDetailsView() -> some View {
        VStack(spacing: 20) {
            seatAvailableView()
            setPriceView()
            setRestrictions()
        }
    }

    @ViewBuilder
    func setPriceView() -> some View {
        HStack {
            TextViewLableText(text: String(localized:"Set a price for the trip"), textFont: .headline)
            Text("(Per person)")
                .foregroundColor(.gray)
            Spacer()
        }
        HStack {
            CurrencyField(value: $viewModel.pricePerPerson, formatter: viewModel.currencyFormatter)
                .font(.headline)
                .frame(width: 100)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Spacer()
        }
    }

    @ViewBuilder
    func setRestrictions() -> some View {
        VStack(spacing: 20) {
            HStack {
                TextViewLableText(text: String(localized:"Restrictions on luggage type and weight"), textFont: .headline)
                Spacer()
            }
            HStack {
                TextViewLableText(text: String(localized:"Please provide luggage size or weight restrictions for passengers."), textFont: .subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }

            HStack {
                TextViewLableText(text: String(localized:"Hand carry"), textFont: .headline)
                    .foregroundColor(.gray)
                Spacer()
                TextField("weight (kg)", text: $viewModel.handCarryWeight)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onReceive(Just(viewModel.handCarryWeight)) { newValue in
                        // Ensure only digits are entered for suitcase weight
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            viewModel.handCarryWeight = filtered
                        }
                    }
                    .frame(width: 100)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            HStack {
                TextViewLableText(text: String(localized:"SuitCase"), textFont: .headline)
                    .foregroundColor(.gray)
                Spacer()
                TextField("weight (kg)", text: $viewModel.suitcaseWeight)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onReceive(Just(viewModel.suitcaseWeight)) { newValue in
                        // Ensure only digits are entered for suitcase weight
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            viewModel.suitcaseWeight = filtered
                        }
                    }
                    .frame(width: 100)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            Toggle(isOn: $viewModel.isSmokingAllowed) {
                Text("Smoking")
            }

            Toggle(isOn: $viewModel.arePetsAllowed) {
                Text("Pets")
            }

            Toggle(isOn: $viewModel.isLanguageRequired) {
                Text("Language")
            }

            if viewModel.isLanguageRequired {
                TextField("E.g German", text: $viewModel.languagePreference)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            HStack {
                TextViewLableText(text: String(localized:"Other relevent details"), textFont: .headline)
                Text("(Optional)")
                    .foregroundColor(.gray)
                Spacer()
            }
            // ""
            ZStack {
                TextEditor(text: $viewModel.otherReleventDetails)
                    .padding(5)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .multilineTextAlignment(.leading)
                    .frame(height: 120)
                    .submitLabel(.done)
                    .focused($isFocused)
                    .onChange(of: viewModel.otherReleventDetails) { _ in
                        if viewModel.otherReleventDetails.last?.isNewline == .some(true) {
                            viewModel.otherReleventDetails.removeLast()
                            isFocused = false
                        }
                    }
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
        }.padding(.bottom, 20)
    }

    @ViewBuilder
    func seatAvailableView() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                TextViewLableText(text: String(localized:"Seats available for passengers"), textFont: .headline)
                
                Stepper(value: $viewModel.seatsAvailable, in: 1...40) {
                    Text("\(viewModel.seatsAvailable) Seat\(viewModel.seatsAvailable > 1 ? "s" : "")")
                        .font(.headline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }

    @ViewBuilder
    func destinationAndSchedule() -> some View {
        VStack(spacing: 20) {
            // From and To Fields
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    // Custom Dotted Line and From Pin
                    circleWithDottedLines()
                    fromWhereToView()
                }
            }

            // Date Picker Section
            VStack(alignment: .leading, spacing: 10) {
                TextViewLableText(text: String(localized:"Choose the date of the trip"), textFont: .headline)
                // Custom Calendar View
                CustomCalendarView(selectedDate: $viewModel.selectedDate)
                    .background(Color.white)
                    .zIndex(1)
            }

            // Time Picker Section
            timePickerView()
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
    func fromWhereToView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                TextViewLableText(text: String(localized:"From"), textFont: .headline)
                TextField("Enter starting location", text: $viewModel.fromLocation)
                    .googlePlacesAutocomplete($viewModel.fromLocation, placeInfo: $viewModel.fromAddressInfo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                TextViewLableText(text: String(localized:"Where to"), textFont: .headline)
                TextField("Enter destination location", text: $viewModel.toLocation)
                    .googlePlacesAutocomplete($viewModel.toLocation, placeInfo: $viewModel.whereToAddressInfo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }

    @ViewBuilder
    func timePickerView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextViewLableText(text: String(localized:"Specify the departure time"), textFont: .headline)
                Spacer()
            }

            DatePicker("", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

//#Preview {
//    CreateTripView()
//}

