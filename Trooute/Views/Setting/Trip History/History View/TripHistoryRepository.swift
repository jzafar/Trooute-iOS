//
//  TripHistoryRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-03.
//

protocol TripHistoryRepositoryProtocol {
    func getTripHistory(completion: @escaping (Result<Response<GetTripsResponse>, Error>) -> Void)
    func getTripDetails(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void)
}
class TripHistoryRepository: TripHistoryRepositoryProtocol{
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getTripHistory(completion: @escaping (Result<Response<GetTripsResponse>, Error>) -> Void) {
        self.networkService.request(url: Apis.tripHistory, method: .GET, completion: completion)
    }
    
    func getTripDetails(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void) {
        let url = Apis.trip + "/\(tripId)"
        self.networkService.request(url: url, method: .GET, completion: completion)
    }
}
