//
//  GooglePlacesModifier.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-07.
//

import SwiftUI

struct GooglePlacesModifier: ViewModifier {
    @Binding var text: String
    @Binding var placeInfo: SearchedLocation?
    @State private var showAutocomplete = false
    @FocusState private var isFocused: Bool

    init(text: Binding<String>, placeInfo: Binding<SearchedLocation?>) {
        _text = text
        _placeInfo = placeInfo
    }

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { focused in
                if focused {
                    isFocused = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                           showAutocomplete = true
                                       }
                }
            }
            .fullScreenCover(isPresented: $showAutocomplete, onDismiss: {
                isFocused = false

            }) {
                GoogleAutocompleteView(selectedAddress: $text, placeInfo: $placeInfo)
                    .onDisappear {
                        isFocused = false
                    }
            }
    }
}

extension View {
    func googlePlacesAutocomplete(_ text: Binding<String>, placeInfo: Binding<SearchedLocation?>) -> some View {
        modifier(GooglePlacesModifier(text: text, placeInfo: placeInfo))
    }
}
