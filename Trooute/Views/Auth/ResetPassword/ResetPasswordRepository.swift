//
//  ResetPasswordRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

protocol ResetPasswordRepositoryProtocol {
    func resetPassword(request: ResetPasswordRequest, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class ResetPasswordRepository: ResetPasswordRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func resetPassword(request: ResetPasswordRequest, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: Apis.forgotPassword, method: .POST, httpBody: request.parameters, completion: completion)
    }
}
