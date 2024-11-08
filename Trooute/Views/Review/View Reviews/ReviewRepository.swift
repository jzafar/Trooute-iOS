//
//  ReviewRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-23.
//

protocol ReviewRepositoryProtocol {
    func getReviews(id: String, completion: @escaping (Result<Response<GetReviewsResponse>, Error>) -> Void)
    func postReview(request: PostReviewRequest, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void)
}

class ReviewRepository: ReviewRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getReviews(id: String, completion: @escaping (Result<Response<GetReviewsResponse>, Error>) -> Void) {
        let url = Apis.review + "/\(id)"
        networkService.request(url: url, method: .GET, completion: completion)
    }
    
    func postReview(request: PostReviewRequest, completion: @escaping (Result<Response<BasicResponse>, Error>) -> Void) {
        networkService.request(url: Apis.review, method: .POST, httpBody: request.toDictionary(), completion: completion)
    }
}
