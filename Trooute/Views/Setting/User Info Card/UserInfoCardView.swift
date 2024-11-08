//
//  UserInfoCardView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SDWebImageSwiftUI
import SwiftUI

struct UserInfoCardView: View {
    @ObservedObject var viewModel: UserInfoCardViewModel
    @State private var image: Image? = nil
    var width = 80.0
    var body: some View {
        VStack {
            HStack {
                userImage()
                VStack(alignment: .leading) {
                    HStack {
                        TextViewLableText(text: viewModel.name, textFont: .headline)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                    }

                    Text(viewModel.gender)
                    HStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.yellow)
                            Text(viewModel.avgRating.formatted(.number.precision(.fractionLength(1))))
                                .font(.headline)

                            Text(viewModel.totalReviews)
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                        }
                        if viewModel.showUserContact {
                            HStack {
                                Spacer()
                                Image("ic_open_inbox")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(.horizontal,5)
                                    .onTapGesture {
                                        viewModel.showChatScreen = true
                                    }
                                Image("ic_call")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        viewModel.phoneCall()
                                    }
                                
                            }
                        }
                    }
                    
                }
                .padding(5)
                .padding(.leading, 0)
                Spacer()
            }
            if viewModel.showReviews {
                WriteReviewView(viewModel: WriteReviewViewModel(tripData: viewModel.tripData))
                    .padding(5)
            }
        }
       
        .cornerRadius(25)
        .fullScreenCover(isPresented: $viewModel.showChatScreen, content: {
            let chatUser = ChatUser(id: viewModel.user.id, name: viewModel.name, seen: true)
            MessageView(messageReceiverInfo: chatUser)
                .environment(\.isInNavigationStack, false)
        })
    }

    @ViewBuilder
    func userImage() -> some View {
        if let img = self.image {
            img
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(width: width, height: width)
                .cornerRadius(width/2)
                .overlay(RoundedRectangle(cornerRadius: width/2).stroke(Color.black, lineWidth: 1))
                .padding(1)
        } else {
            WebImage(url: URL(string: viewModel.photo)) { image in
                image.resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            } placeholder: {
                Image("profile_place_holder")
                    .resizable()
            }
            .onSuccess { image, _, _ in
                DispatchQueue.main.async {
                    self.image =  Image(uiImage: image)
                }
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: width, height: width)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .padding(5)
            .padding(.trailing, 0)
        }
        
    }
}

//#Preview {
//    let data = MockDate.getTripsResponse()?.data?.first?.driver
//    UserInfoCardView(viewModel: UserInfoCardViewModel(user: data!))
//}
