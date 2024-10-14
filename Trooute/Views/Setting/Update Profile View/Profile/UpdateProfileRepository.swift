//
//  UpdateProfileRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

protocol UpdateProfileRepositoryProtocol {
    func updateMe(request: UpdateProfileRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}

class UpdateProfileRepository: UpdateProfileRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func updateMe(request: UpdateProfileRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.updateProfile, method: .PATCH, httpBody: request.parameters, isMultipart: true, completion: completion)
    }
}
