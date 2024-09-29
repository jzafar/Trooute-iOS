//
//  UserInfoCardView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserInfoCardView: View {
    @ObservedObject var viewModel: UserInfoCardViewModel
    var body: some View {
        HStack {
            userImage()
            VStack (alignment: .leading){
                HStack {
                    TextViewLableText(text: viewModel.name, textFont: .headline)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                }
                
                Text(viewModel.gender)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                    Text(viewModel.avgRating.formatted(.number.precision(.fractionLength(1))))
                        .font(.headline)
                    
                    Text(viewModel.totalReviews)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                
            }
            .padding(5)
            .padding(.leading,0)
            Spacer()
        }
        .cornerRadius(25)
    }
    
    @ViewBuilder
    func userImage() -> some View {
        WebImage(url: URL(string: viewModel.photo)) { image in
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
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .padding(5)
            .padding(.trailing,0)
    }
}

#Preview {
    let data = MockDate.getTripsResponse()?.data?.first?.driver
    UserInfoCardView(viewModel: UserInfoCardViewModel(user: data!))
}
