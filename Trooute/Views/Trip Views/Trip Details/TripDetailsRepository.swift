//
//  TripDetailsRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-15.
//

protocol TripDetailsRepositoryProtocol {
    func getTripDetails(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void)
}
class TripDetailsRepository: TripDetailsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getTripDetails(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void) {
        networkService.request(url: Apis.trip + "/\(tripId)", method: .GET, completion: completion)
    }
}
