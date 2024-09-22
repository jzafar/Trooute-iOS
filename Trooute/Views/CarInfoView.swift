//
//  CarInfoView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct CarInfoView: View {
    var body: some View {
        HStack {
            carImageView()
            carDetailsView()
            Spacer()
        }
    }
    
    @ViewBuilder
    func carImageView() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: 80, height: 80)
            .overlay {
                Image(systemName: "car.fill")
                    .resizable()
                    .padding(2)
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.black, lineWidth: 1)
            }
    }
    
    @ViewBuilder
    func carDetailsView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                TextViewLableText(text: "Honda City", textFont: .headline)
                Spacer()
                HStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .frame(height: 40)
                        .frame(minWidth: 70)
                        .foregroundColor(Color("LightBlue"))
                        .overlay {
                        Text("NLG 11D")
                                .foregroundStyle(Color("DarkBlue"))
                    }
                    Button(action: {}) {
                        Image(systemName: "pencil")
                            .font(.largeTitle)
                            .foregroundStyle(Color("DarkBlue"))
                    }
                    
                }
                
                
            }
            
            Text("2023")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            HStack(spacing: 2) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 15, height: 15)
                TextViewLableText(text: "Green", textFont: .headline)
                    .padding(.leading, 10)
            }
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                TextViewLableText(text: "5.0", textFont: .headline)
                Text("(100)")
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}

#Preview {
    CarInfoView()
}
