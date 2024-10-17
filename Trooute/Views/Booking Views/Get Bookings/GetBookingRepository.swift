//
//  GetBookingRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-17.
//

protocol GetBookingRepositoryProtocol {
    func getBookings(completion: @escaping (Result<Response<GetBookingsResponse>, Error>) -> Void)
}

class GetBookingRepository: GetBookingRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getBookings(completion: @escaping (Result<Response<GetBookingsResponse>, Error>) -> Void) {
        networkService.request(url: Apis.booking, method: .GET, completion: completion)
    }
}
