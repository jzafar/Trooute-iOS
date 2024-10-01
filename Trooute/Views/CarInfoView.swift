//
//  CarInfoView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarInfoView: View {
    var viewModel: CarInfoViewModel
    var body: some View {
        HStack {
            carImageView()
            carDetailsView()
            Spacer()
        }
    }
    
    @ViewBuilder
    func carImageView() -> some View {
        WebImage(url: URL(string: viewModel.photo)) { image in
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
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            .padding(1)
    }
    
    @ViewBuilder
    func carDetailsView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                TextViewLableText(text: viewModel.carMakeModel, textFont: .headline)
                Spacer()
                HStack {
                    if !viewModel.isEditable {
                        Button(action: {}) {
                            Image(systemName: "pencil")
                                .font(.title).bold()
                                .foregroundStyle(Color("DarkBlue"))
                        }
                    }
                }
                
                
            }
            HStack {
                Text(viewModel.year)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                
                Spacer()
            
                Text(viewModel.carDetails.registrationNumber)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .foregroundStyle(Color("DarkBlue"))
                    .background(Color("LightBlue"))
                    .frame(height: 40)
                    .cornerRadius(20)
                    
            }
            
            HStack(spacing: 2) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 15, height: 15)
                TextViewLableText(text: viewModel.carDetails.color, textFont: .headline)
                    .padding(.leading, 10)
            }
//            HStack(spacing: 2) {
//                Image(systemName: "star.fill")
//                    .foregroundStyle(Color.yellow)
//                TextViewLableText(text: "5.0", textFont: .headline)
//                Text("(100)")
//                    .font(.subheadline)
//                    .foregroundStyle(Color.gray)
//            }
        }
    }
}

#Preview {
    let loginResponse = MockDate.getLoginResponse()!
    CarInfoView(viewModel: CarInfoViewModel(carDetails: loginResponse.data!.carDetails!))
}
