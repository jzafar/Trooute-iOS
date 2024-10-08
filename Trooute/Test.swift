import SwiftUI
import Combine
import GooglePlaces

struct PlacesSearchView: View {
    @StateObject private var viewModel = PlacesViewModel()
    
    var body: some View {
        VStack {
            TextField("Search for places", text: $viewModel.query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(viewModel.searchResults) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.headline)
                    Text(place.formatted_address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Search Places")
    }
}

#Preview {
    PlacesSearchView()
}

class PlacesViewModel: ObservableObject {
    @Published var searchResults: [Place] = []
    @Published var query: String = ""
    private var cancellable: AnyCancellable?
    
    private let apiKey = Constants.google_map_api_key
    
    init() {
        cancellable = $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if !query.isEmpty {
                    self?.searchPlaces(query: query)
                } else {
                    self?.searchResults = []
                }
            }
    }
    
    func searchPlaces(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.searchResults = self.parsePlaces(data: data)
                }
            }
        }.resume()
    }
    
    private func parsePlaces(data: Data) -> [Place] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GooglePlacesResponse.self, from: data)
            return response.results
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}

struct GooglePlacesResponse: Codable {
    let results: [Place]
}

struct Place: Codable, Identifiable {
    let id = UUID()
    let name: String
    let formatted_address: String
}

