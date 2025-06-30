//
//  ConnectAccountRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-27.
//
import AuthenticationServices
import Foundation
import SwiftLoader
protocol ConnectAccountRepositoryProtocol {
    func updatePaypalToServer(request: UpdatePaypalRequest ,completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
    func connectStripeAccount(completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}


class ConnectAccountRepository: NSObject, ConnectAccountRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func updatePaypalToServer(request: UpdatePaypalRequest ,completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.updatePayPal, method: .POST, httpBody: request.toDictionary(), completion: completion)
    }
    
    func connectStripeAccount(completion: @escaping (Result<Response<SigninResponse>, any Error>) -> Void) {
        networkService.request(url: Apis.connectStripe, method: .POST, httpBody: nil, completion: completion)
    }
}
