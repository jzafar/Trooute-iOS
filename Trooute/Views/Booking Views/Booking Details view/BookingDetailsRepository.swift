//
//  BookingDetailsRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-17.
//

protocol BookingDetailsRepositoryProtocol {
    func getBookingDetails(bookingId: String, completion: @escaping (Result<Response<GetBookingDetailsResponse>, Error>) -> Void)
    func cancelBooking(bookingId: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
    func approveBooking(bookingId: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
    func confirmBooking(bookingId: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class BookingDetailsRepository: BookingDetailsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getBookingDetails(bookingId: String,completion: @escaping (Result<Response<GetBookingDetailsResponse>, Error>) -> Void) {
        let url = Apis.booking + "/\(bookingId)"
        networkService.request(url: url, method: .GET, completion: completion)
    }
    
    func cancelBooking(bookingId: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        let url = Apis.booking + "/\(bookingId)/cancel"
        networkService.request(url: url, method: .POST, completion: completion)
    }
    
    func approveBooking(bookingId: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        let url = Apis.booking + "/\(bookingId)/approve"
        networkService.request(url: url, method: .POST, completion: completion)
    }
    
    func confirmBooking(bookingId: String, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        let url = Apis.booking + "/\(bookingId)/confirm"
        networkService.request(url: url, method: .POST, completion: completion)
    }
}
