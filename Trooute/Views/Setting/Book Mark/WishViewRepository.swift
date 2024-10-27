//
//  WishViewRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-19.
//


protocol WishViewRepositoryProtocol {
    func getTrips(completion: @escaping (Result<Response<GetTripListResponse>, Error>) -> Void)
}

class WishViewRepository: WishViewRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getTrips(completion: @escaping (Result<Response<GetTripListResponse>, Error>) -> Void) {
        networkService.request(url: Apis.getWishList, method: .GET, completion: completion)
    }
}
