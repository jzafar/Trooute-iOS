//
//  WriteReviewView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-04.
//

import SwiftUI

struct WriteReviewView: View {
    @StateObject var viewModel: WriteReviewViewModel
    var userModel = UserUtils.shared
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            HStack {
                TextViewLableText(text: viewModel.isCarReview ? "Rating" : "Reviews")
                Spacer()
                Image(systemName: viewModel.isfullView ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 20, height: 10)
                    .foregroundColor(.black)
                    .onTapGesture {
                        withAnimation {
                            viewModel.isfullView.toggle()
                        }
                    }
            }
            if viewModel.isfullView {
                if !viewModel.isCarReview {
                    if viewModel.booking?.driverId == userModel.user?.id { // it means user was driver
                        if let myReview = viewModel.reviewsGivenToUser { // Review given to user from driver
                            self.showReview(review: myReview, name: viewModel.tripData?.bookings?.first?.user?.name, forDriver: true)
                        } else {
                            self.writeReviewView(expText: "Experience with passenger")
                        }

                        if let myReview = viewModel.reviewsGivenToDriver { // Review given to driver from user
                            self.showReview(review: myReview, name: viewModel.tripData?.bookings?.first?.user?.name, forDriver: false)
                        }

                    } else {
                        if viewModel.booking?.user?.id != viewModel.booking?.driverId {
                            // Review given to user from user
                            if viewModel.reviewsGivenToUsersByUser?.count ?? 0 > 0 {
                                let myReviewToOtherUser = viewModel.reviewsGivenToUsersByUser?.filter({ $0.user == userModel.user?.id }).first
                                let otherUserReviewToMe = viewModel.reviewsGivenToUsersByUser?.filter({ $0.target == userModel.user?.id }).first

                                if let review = myReviewToOtherUser {
                                    self.showReview(review: review, name: viewModel.tripData?.bookings?.first?.user?.name, forDriver: true)
                                } else {
                                    self.writeReviewView(expText: "Experience with passenger")
                                }

                                if let review = otherUserReviewToMe {
                                    self.showReview(review: review, name: viewModel.tripData?.bookings?.first?.user?.name, forDriver: true)
                                }

                            } else {
                                self.writeReviewView(expText: "Experience with passenger")
                            }

                        } else {
                            // Review given to driver from user
                            if let review = viewModel.reviewsGivenToDriver,
                                viewModel.booking != nil {
                                self.showReview(review: review, name: viewModel.tripData?.bookings?.first?.user?.name, forDriver: true)
                            }
                            // Review given to user from driver
                            if let review = viewModel.reviewsGivenToUser,
                               review.target == viewModel.booking?.user?.id { // check if driver review is for booking user
                                self.showReview(review: review, name: viewModel.tripData?.bookings?.first?.user?.name, forDriver: true)
                            } else {
                                if viewModel.booking == nil,
                                   viewModel.tripData?.isDriverForReviews ?? false { // it's a driver card
                                    
                                    if let review = viewModel.reviewsGivenToDriver { // My review to driver
                                        self.showReview(review: review, name: "My review", forDriver: true)
                                    } else {
                                        self.writeReviewView(expText: "Experience with driver")
                                    }
                                    
                                    if let review = viewModel.reviewsGivenToUser { // check if driver review is for booking user
                                        self.showReview(review: review, name: viewModel.tripData?.driver?.name, forDriver: true)
                                    }
                                    
                                    
                                } else {
                                    self.writeReviewView(expText: "Experience with passenger")
                                }
                            }
                        }
                    }
                } else {
                    self.carRatingView()
                }
            }
        }
    }

    @ViewBuilder
    func writeReviewView(expText: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(expText)
                    .font(.callout)
                Spacer()
                StarRateView(rate: $viewModel.rating)
            }
            Text("Share your thoughts")
                .font(.callout)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 200)

                TextField("Did you enjoy the ride?...", text: $viewModel.reviewText, axis: .vertical)
                    .padding()
                    .font(.callout)
                    .frame(height: 200, alignment: .top)
                    .background(Color.clear)
                    .multilineTextAlignment(.leading)
            }
            self.submitButton()
        }
    }

    @ViewBuilder
    func showReview(review: Review, name: String?, forDriver: Bool) -> some View {
        VStack(alignment: .leading) {
            if review.target == viewModel.booking?.user?.id {
                Text("My Review")
                    .bold()
            } else {
                Text(name ?? "Not Provided")
                    .bold()
            }

            Text(review.comment ?? "")
                .font(.callout)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray)
            HStack {
                Text("Experience with \(forDriver ? "passenger" : "driver")")
                    .font(.callout)
                Spacer()
                StarRateView(rate: .constant(review.rating ?? 0.0))
            }
            Divider()
        }
    }

    @ViewBuilder
    func submitButton() -> some View {
        PrimaryGreenButton(title: "Submit") {
            hideKeyboard()
            viewModel.submitReview()
        }.padding(.vertical, 5)
    }

    @ViewBuilder
    func carRatingView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Rate the Vehicle")
                    .font(.callout)
                Spacer()
                if let carReview = viewModel.reviewsGivenToCar {
                    StarRateView(rate: .constant(carReview.rating ?? 0.0))
                } else {
                    StarRateView(rate: $viewModel.rating)
                }
            }
        }
        if viewModel.reviewsGivenToCar == nil {
            submitButton()
        }
    }
}

// #Preview {
//    WriteReviewView()
// }
