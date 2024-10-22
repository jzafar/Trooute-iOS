
//
//  GetBookingRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-17.
//

protocol WebViewRepositoryProtocol {
    func paymentSuccess(url: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class WebViewRepository: WebViewRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func paymentSuccess(url: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: url, method: .GET, completion: completion)
    }
}
