//
//  TripDetailsRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-15.
//

protocol TripDetailsRepositoryProtocol {
    func getTripDetails(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void)
    func updateTripStatus(tripId: String, status: TripStatus, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
    func getPickupStatus(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void)
}
class TripDetailsRepository: TripDetailsRepositoryProtocol, TripCardRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getTripDetails(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void) {
        networkService.request(url: Apis.trip + "/\(tripId)", method: .GET, completion: completion)
    }
    
    func updateTripStatus(tripId: String, status: TripStatus, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        let url =  Apis.updateTripStatus + "/\(tripId)"
        networkService.request(url: url, method: .PATCH, queryParams: ["status" : status.rawValue], completion: completion)
    }
    
    func getPickupStatus(tripId: String, completion: @escaping (Result<Response<GetTripDetailsResponse>, Error>) -> Void) {
        networkService.request(url: Apis.getPickupStatus + "/\(tripId)", method: .GET, completion: completion)
    }
    
    func addToWishList(tripId: String, completion: @escaping (Result<Response<SigninResponse>, any Error>) -> Void) {
        let url = Apis.trip + "/\(tripId)" + "/add-to-wish-list"
        networkService.request(url: url, method: .POST, completion: completion)
    }
}
