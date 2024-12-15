//
//  SettingsRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-19.
//


protocol SettingsRepositoryProtocol {
    func switchDriverMode(completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
    func signout(request: SignoutRequest ,completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
    func getMe(completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
    func deleteMe(completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class SettingsRepository: SettingsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func switchDriverMode(completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: Apis.switchDriverMode, method: .PATCH, completion: completion)
    }
    
    func signout(request: SignoutRequest ,completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void){
        networkService.request(url: Apis.signout, method: .POST, httpBody: request.toDictionary(), completion: completion)
    }
    
    func getMe(completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        self.networkService.request(url: Apis.getMe, method: .GET, completion: completion)
    }
    
    func deleteMe(completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        self.networkService.request(url: Apis.deletMe, method: .DELETE, completion: completion)
    }
}
