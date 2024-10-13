//
//  MainTabViewRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//


protocol GetMeRepositoryProtocol {
    func getMe(completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}
class MainTabViewRepository: GetMeRepositoryProtocol{
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    func getMe(completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        self.networkService.request(url: Apis.getMe, method: .GET, completion: completion)
    }
}

