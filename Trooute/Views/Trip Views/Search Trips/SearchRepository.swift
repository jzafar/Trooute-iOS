//
//  SearchRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-26.
//

class SearchRepository: TripRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getTrips(request: GetTripsRequest, completion: @escaping (Result<Response<GetTripsResponse>, Error>) -> Void) {
        networkService.request(url: Apis.trip, method: .GET, queryParams: request.parameters, completion: completion)
    }
    
    func getDriverTrips(request: GetTripsRequest, completion: @escaping (Result<Response<GetTripListResponse>, Error>) -> Void) {
        networkService.request(url: Apis.trip, method: .GET, queryParams: request.parameters, completion: completion)
    }
}
