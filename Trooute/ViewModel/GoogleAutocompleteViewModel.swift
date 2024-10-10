//
//  GoogleAutocompleteViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-09.
//

import Combine
import MapKit
import SwiftUI

class GoogleAutocompleteViewModel: NSObject, ObservableObject {
    @Published var locationResults: [MKLocalSearchCompletion] = []
    @Published var searchTerm = ""

    private var cancellables: Set<AnyCancellable> = []

    private var searchCompleter = MKLocalSearchCompleter()
    private var currentPromise: ((Result<[MKLocalSearchCompletion], Error>) -> Void)?

    override init() {
        super.init()
        searchCompleter.delegate = self

        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ currentSearchTerm in
                self.searchTermToResults(searchTerm: currentSearchTerm)
            })
            .sink(receiveCompletion: { _ in
                // handle error
            }, receiveValue: { results in
                self.locationResults = results
            })
            .store(in: &cancellables)
    }

    func searchTermToResults(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
        Future { promise in
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromise = promise
        }
    }

    func reconcileLocation(location: MKLocalSearchCompletion, completion: @escaping (SearchedLocation?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
                completion(SearchedLocation(coordinate: coordinate, title: location.title, subtitle: location.subtitle))
            } else {
                completion(nil)
            }
        }
    }
}

extension GoogleAutocompleteViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        currentPromise?(.success(completer.results))
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // could deal with the error here, but beware that it will finish the Combine publisher stream
        // currentPromise?(.failure(error))
    }
}
