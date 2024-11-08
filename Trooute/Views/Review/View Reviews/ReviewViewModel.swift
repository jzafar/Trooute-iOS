//
//  ReviewViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-23.
//
import Foundation
import SwiftLoader
class ReviewViewModel: ObservableObject {
    let userId: String
    @Published var user: User?
    @Published var reviews: [Reviews] = []
    private let repository = ReviewRepository()
    init(userId: String) {
        self.userId = userId
    }
    
    func fetchReviews() {
        SwiftLoader.show(title: "Loading...", animated: true)
        repository.getReviews(id: self.userId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success,
                   let reviews = response.data.data {
                    if let target = reviews.first?.target {
                        self?.user = target
                        
                    }
                    if (reviews.first?.user) != nil {
                        self?.reviews = reviews
                    } else {
                        self?.reviews = []
                    }
                    
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
    func getUrl(url: String?) -> String {
        var imageUrl = "\(Constants.baseImageUrl)"
        if let photo = url {
            imageUrl = "\(Constants.baseImageUrl)/\(photo)"
        }
        return imageUrl
    }
}
