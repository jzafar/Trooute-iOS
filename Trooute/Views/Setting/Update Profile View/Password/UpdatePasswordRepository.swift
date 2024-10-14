//
//  UpdatePasswordRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

protocol UpdatePasswordProtocol {
    func updatePassword(request: UpdatePasswordRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}

class UpdatePasswordRepository: UpdatePasswordProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func updatePassword(request: UpdatePasswordRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.updatePassword, method: .PATCH, httpBody: request.parameters, completion: completion)
    }
}
