//
//  ReviewView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-23.
//

import SDWebImageSwiftUI
import SwiftUI
struct ReviewView: View {
    @StateObject var viewModel: ReviewViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if let target = viewModel.user {
                        UserInfoCardView(viewModel: UserInfoCardViewModel(user: target))
                    }
                }
                Section {
                    HStack {
                        TextViewLableText(text: String(localized:"Reviews"))
                        Spacer()
                    }
                }.listRowBackground(Color.clear)

                if viewModel.reviews.count == 0 {
                    Section {
                        HStack {
                            Spacer()
                            Text("No Reviews submitted for this User")
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }.listRowBackground(Color.clear)
                } else {
                    Section {
                        ForEach(viewModel.reviews) { review in
                            if let user = review.user {
                                VStack {
                                    HStack(alignment: .top) { 
                                        WebImage(url: URL(string: viewModel.getUrl(url: user.photo))) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            Image("profile_place_holder")
                                                .resizable()
                                        }

                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                        .padding(1)

                                        VStack(alignment: .leading) {
                                            TextViewLableText(text: user.name, textFont: .headline)

                                            HStack {
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .frame(width: 16, height: 16)
                                                    .foregroundColor(.yellow)
                                                if let rating = review.rating {
                                                    Text(rating.formatted(.number.precision(.fractionLength(1))))
                                                        .font(.body)
                                                } else {
                                                    Text("Not provided")
                                                        .font(.body)
                                                }
                                                Spacer()
                                            }

                                            Text(review.comment ?? "")
                                                .font(.body)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            .onAppear {
                viewModel.fetchReviews()
            }.navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                XMarkButton {
                    dismiss()
                }.padding()
            }
        }
    }
}

// #Preview {
//    ReviewView(viewModel: ReviewViewModel(userId: "670aaabc5d1878c9830ffdbc"))
// }
