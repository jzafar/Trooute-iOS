//
//  GoogleAutocompleteView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-07.
//

import MapKit
import SwiftUI

struct GoogleAutocompleteView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedAddress: String
    @Binding var placeInfo: SearchedLocation?
    @StateObject private var viewModel = GoogleAutocompleteViewModel()
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Type address here ...", text: $viewModel.searchTerm)
                }
                Section {
                    ForEach(viewModel.locationResults, id: \.self) { location in
                        VStack(alignment: .leading) {
                            Text(location.title)
                            Text(location.subtitle)
                                .font(.system(.caption))
                        }.onTapGesture {
                            viewModel.reconcileLocation(location: location) { finalPlace in
                                self.selectedAddress = location.title + " " + location.subtitle
                                self.placeInfo = finalPlace
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }.navigationTitle("Search Address")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        XMarkButton {
                            self.presentationMode.wrappedValue.dismiss()
                        }.padding()
                    }
                }
        }
        
    }
}
