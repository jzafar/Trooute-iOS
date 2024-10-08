//
//  GooglePlacesModifier.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-07.
//

import SwiftUI
import GooglePlaces

struct GooglePlacesModifier: ViewModifier {
    @Binding var text: String
    @State private var showAutocomplete = false
    @FocusState private var isFocused: Bool
    private let apiKey = Constants.google_map_api_key
    
    init(text: Binding<String>) {
        _text = text
        GMSPlacesClient.provideAPIKey(apiKey)
    }

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
                        .onChange(of: isFocused) { focused in
                            if focused {
                                showAutocomplete = true
                            }
                        }
            .sheet(isPresented: $showAutocomplete) {
                GoogleAutocompleteView(selectedAddress: $text)
            }
    }
}

extension View {
    func googlePlacesAutocomplete(_ text: Binding<String>) -> some View {
        self.modifier(GooglePlacesModifier(text: text))
    }
}
