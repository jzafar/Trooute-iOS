//
//  TripCardRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-15.
//

import Foundation

protocol TripCardRepositoryProtocol {
    func addToWishList(tripId: String, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}

class TripCardRepository: TripCardRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func addToWishList(tripId: String, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        let url = Apis.trip + "/\(tripId)" + "/add-to-wish-list"
        networkService.request(url: url, method: .POST, completion: completion)
    }
}

