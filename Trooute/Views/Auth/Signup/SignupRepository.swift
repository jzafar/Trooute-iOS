//
//  SignupRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

// LoginRepository.swift
import Foundation

protocol SignupRepositoryProtocol {
    func signup(signinRequest: SignupRequest, completion: @escaping (Result<Response<SignupResponse>, Error>) -> Void)
}

class SignupRepository: SignupRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func signup(signinRequest: SignupRequest, completion: @escaping (Result<Response<SignupResponse>, Error>) -> Void) {
        networkService.request(url: Apis.signup, method: .POST, httpBody: signinRequest.parameters, isMultipart: true, completion: completion)
    }
}
