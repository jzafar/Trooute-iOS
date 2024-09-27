//
//  DriverCarView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI
import SDWebImageSwiftUI

struct DriverCarView: View {
    @StateObject var viewModel: DriverCarViewModel
    let url = ""
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .center, spacing: 5) {
                // User Profile Image
                driverImage()
                driverInfo()
                
                Spacer()
                // Car Image
                carImageView()
            }
            .padding(5)
            
            // Car Model and Registration Number
            carMakeAndModel()
            
        }
        .background(Color(hex:"F9F9FB"))
        .cornerRadius(10)
    }
    
    @ViewBuilder
    func driverImage() -> some View {
        WebImage(url: URL(string: viewModel.driverPicture)) { image in
                image.resizable()
            } placeholder: {
                Image("profile_place_holder")
                    .resizable()
            }
            .onSuccess { image, data, cacheType in
               
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 75, height: 75)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .padding(1)
    }
    
    @ViewBuilder
    func driverInfo() ->  some View {
        VStack(alignment: .leading, spacing: 8) {
            // User Name and Verified Icon
            HStack {
                TextViewLableText(text: viewModel.driver.name, textFont: .headline)
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.primaryGreen)
            }
            
            // Gender
            TextViewLableText(text: viewModel.driver.gender ?? "male", textFont: .body)
            
            // Rating and Reviews Section
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.yellow)
                    Text(viewModel.avgRating.formatted(.number.precision(.fractionLength(1))))
                        .font(.body)
                }
                
                Text(viewModel.totalReviews)
                    .font(.body)
                    .foregroundColor(Color.gray.opacity(0.7))
            }
            .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    func carImageView() -> some View {
        WebImage(url: URL(string: viewModel.carPicture)) { image in
                image.resizable()
                image.aspectRatio(contentMode: .fit)
            } placeholder: {
                Image("place_holder")
                    .resizable()
            }
            .onSuccess { image, data, cacheType in
               
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            .padding(1)
    }
    
    @ViewBuilder
    func carMakeAndModel() -> some View {
            HStack(alignment: .top) {
                TextViewLableText(text: viewModel.carMake, textFont: .footnote)
                TextViewLableText(text: "-", textFont: .footnote)
                    .foregroundColor(Color.gray)
                
                TextViewLableText(text: viewModel.registrationNumber, textFont: .footnote)
            }
            .padding(.horizontal, 5)
            .padding(.top,-20)
    }
}

#Preview {
    DriverCarView(viewModel: DriverCarViewModel(driver: Driver(id: "123", carDetails: CarDetails(color: "green", driverLicense: "", make: "Peugout", model: "2021", photo: "carphoto-1707596900138-16302-img_20240210_212807.jpg", registrationNumber: "NLG11d", reviews: [], reviewsStats: nil, year: nil), driverMode: true, email: "", isApprovedDriver: true, name: "Muhammad Jahngir Zafar", photo: "cover-image-1707597881040.jpg", gender: "male", reviewsStats: ReviewsStats(avgRating: 4.5, ratings: Ratings(oneStar: 4.0, twoStars: 4.0, threeStars: 4.0, fourStars: 4.0, fiveStars: 4.0), totalReviews: 10))))
}
