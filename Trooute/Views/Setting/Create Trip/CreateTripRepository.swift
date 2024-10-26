//
//  CreateTripRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-25.
//

protocol CreateTripRepositoryProtocol {
    func createTrip(request: CreateTripRequest, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class CreateTripRepository: CreateTripRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func createTrip(request: CreateTripRequest, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: Apis.trip, method: .POST, httpBody: request.toDictionary(), completion: completion)
    }
}

