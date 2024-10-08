//
//  GoogleAutocompleteView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-07.
//

import SwiftUI
import GooglePlaces

struct GoogleAutocompleteView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedAddress: String
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        var parent: GoogleAutocompleteView
        
        init(_ parent: GoogleAutocompleteView) {
            self.parent = parent
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            parent.selectedAddress = place.formattedAddress ?? ""
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
