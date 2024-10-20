//
//  DriverRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//

protocol DriverRepositoryProtocol {
    func becomeDriver(request: UpdateCarInfoRequests, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
    func updateCarInfo(request: UpdateCarInfoRequests, completion: @escaping (Result<Response<UpdateCarInfoResponse>, Error>) -> Void)
}
class DriverRepository: DriverRepositoryProtocol{
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func becomeDriver(request: UpdateCarInfoRequests,completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: Apis.becomeADriver, method: .POST, httpBody: request.parameters, isMultipart: true, completion: completion)
    }
    
    func updateCarInfo(request: UpdateCarInfoRequests, completion: @escaping (Result<Response<UpdateCarInfoResponse>, Error>) -> Void) {
        networkService.request(url: Apis.updateCarInfo, method: .POST, httpBody: request.parameters, isMultipart: true, completion: completion)
    }
}


    
