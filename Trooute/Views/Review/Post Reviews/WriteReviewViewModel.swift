//
//  WriteReviewViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-04.
//
import Foundation
import SwiftLoader
class WriteReviewViewModel: ObservableObject {
    @Published var reviewText = ""
    @Published var rating: Double = 0.0
    @Published var isfullView = false
    @Published var reviewPosted = false
    var isCarReview = false
    @Published var tripData: TripsData?
    
    @Published var reviewsGivenToCar: Review?
    @Published var reviewsGivenToDriver: Review?
    @Published var reviewsGivenToUser: Review?
    @Published var reviewsGivenToUsersByUser: [Review]?
    @Published var booking: Booking?
    private let userModel = UserUtils.shared
    init(isCarReview: Bool = false, tripData: TripsData? = nil) {
        self.isCarReview = isCarReview
        self.tripData = tripData
        reviewsGivenToCar = tripData?.bookings?.first?.reviewsGivenToCar
        reviewsGivenToDriver = tripData?.bookings?.first?.reviewsGivenToDriver
        reviewsGivenToUser = tripData?.bookings?.first?.reviewsGivenToUser
        reviewsGivenToUsersByUser = tripData?.bookings?.first?.reviewsGivenToUsersByUser
        if tripData?.isDriverForReviews ?? false { // driver review to user
            booking = nil
        } else {
            booking = tripData?.bookings?.first
        }
        
    }
    private let repositiry = ReviewRepository()
    
    func submitReview() {
        if rating == 0.0 {
            BannerHelper.displayBanner(.error, message: "Please give some rating")
            return
        }
        var targetType: TargetType = .User
        guard let tripId = tripData?.id else {
            return
        }
        var targetId = ""
        if booking == nil { // It's for driver
            targetId = tripData?.driver?.id ?? ""
            targetType = .Driver
        } else {
            targetId = booking?.user?.id ?? ""
            targetType = .User
        }
        if isCarReview {
            targetType = .Car
            targetId = tripData?.driver?.id ?? ""
        }
        let request = PostReviewRequest(trip: tripId, targetId: targetId, targetType: targetType, comment: self.reviewText.trim(), rating: self.rating)
        SwiftLoader.show(title: "Posting...", animated: true)
        self.repositiry.postReview(request: request) { result in
            SwiftLoader.hide()
            switch result {
            case .success(let response):
                if response.data.success {
//                    self?.reviewPosted = true
                    NotificationCenter.default.post(name: Notification.ReviewPosted,
                                                    object: nil, userInfo:nil)
                } else {
                    BannerHelper.displayBanner(.error, message:  response.data.message)
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message:  failure.localizedDescription)
            }
        }
    }
}
