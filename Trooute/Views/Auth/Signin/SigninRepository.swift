//
//  SigninRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

// LoginRepository.swift
import Foundation

protocol SigninRepositoryProtocol {
    func signin(signinRequest: SigninRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}

class SigninRepository: SigninRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func signin(signinRequest: SigninRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.signin, method: .POST, httpBody: signinRequest.parameters, completion: completion)
    }
}
