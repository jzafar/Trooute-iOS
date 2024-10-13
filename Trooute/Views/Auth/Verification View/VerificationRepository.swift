//
//  VerificationRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

protocol VerificationRepositoryProtocol {
    func verifyOTP(otp: OTPVerificationRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
    func resendOTP(resendOtp: ResendOTPRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}

class VerificationRepository: VerificationRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func verifyOTP(otp: OTPVerificationRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.verifyOTP, method: .POST, httpBody: otp.parameters, completion: completion)
    }
    
    func resendOTP(resendOtp: ResendOTPRequest, completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.resendOTP, method: .POST, httpBody: resendOtp.parameters, completion: completion)
    }
}
