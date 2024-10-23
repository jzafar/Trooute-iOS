//
//  ReviewView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-23.
//

import SwiftUI
import SDWebImageSwiftUI
struct ReviewView: View {
    @ObservedObject var userModel = UserUtils.shared
    @ObservedObject var viewModel: ReviewViewModel
    var body: some View {
        VStack(spacing: 20) {
            if let target = viewModel.reviews.first?.target {
                UserInfoCardView(viewModel: UserInfoCardViewModel(user: target))
            }
            
            TextViewLableText(text: "Reviews")
            
            List {
                ForEach(viewModel.reviews) { review in
                    if let user = review.user {
                        VStack {
                            HStack {
                                WebImage(url: URL(string: viewModel.getUrl(url: user.photo)))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    
                            }
                            HStack {
                                VStack {
                                    TextViewLableText(text: user.name, textFont: .headline)
                                    
                                    TextViewLableText(text: user.gender ?? "Not provided", textFont: .body)
                                    HStack {
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.yellow)
                                            if let rating = review.rating {
                                                Text(rating.formatted(.number.precision(.fractionLength(1))))
                                                    .font(.body)
                                            } else {
                                                Text("Not Provided")
                                                    .font(.body)
                                            }
                                            
                                        }
                                        
                                        Text(review.comment ?? "")
                                            .font(.body)
                                            .multilineTextAlignment(.leading)
                                            
                                    }
                                }
                            }
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
            if viewModel.reviews.count == 0 {
                HStack {
                    Spacer()
                    Text("No Reviews submitted for this User")
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
        }
        
    }
}

#Preview {
    ReviewView(viewModel: ReviewViewModel(userId: "670aaabc5d1878c9830ffdbc"))
}
