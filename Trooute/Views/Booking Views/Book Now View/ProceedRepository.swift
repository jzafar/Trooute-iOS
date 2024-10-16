//
//  ProceedRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-16.
//


protocol ProceedRepositoryProtocol {
    func createBooking(request: CreateBookingRequest, completion: @escaping (Result<Response<CreateBookingResponse>, Error>) -> Void)
}

class ProceedRepository: ProceedRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func createBooking(request: CreateBookingRequest, completion: @escaping (Result<Response<CreateBookingResponse>, Error>) -> Void) {
        networkService.request(url: Apis.booking, method: .POST, httpBody: request.toDictionary(), completion: completion)
    }
}
