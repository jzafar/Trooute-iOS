//
//  TripRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-14.
//

protocol TripRepositoryProtocol {
    func getNearByTrips(request: GetTripsRequest, completion: @escaping (Result<Response<GetTripsResponse>, Error>) -> Void)
}

class TripRepository: TripRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getNearByTrips(request: GetTripsRequest, completion: @escaping (Result<Response<GetTripsResponse>, Error>) -> Void) {
        networkService.request(url: Apis.trip, method: .GET, queryParams: request.parameters, httpBody: nil, isMultipart: false, completion: completion)
    }
}
