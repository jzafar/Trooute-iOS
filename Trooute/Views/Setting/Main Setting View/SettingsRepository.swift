//
//  SettingsRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-19.
//


protocol SettingsRepositoryProtocol {
    func switchDriverMode(completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class SettingsRepository: SettingsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func switchDriverMode(completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: Apis.switchDriverMode, method: .PATCH, completion: completion)
    }
}
