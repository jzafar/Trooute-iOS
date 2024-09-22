//
//  UserInfoCardView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct UserInfoCardView: View {
    var body: some View {
        HStack {
            Circle().stroke(Color.black, lineWidth: 1)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                )
                .foregroundColor(Color(UIColor.systemGray5))
                .padding(5)
                .padding(.trailing,0)
            VStack (alignment: .leading){
                HStack {
                    TextViewLableText(text: "Jahangir", textFont: .headline)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                }
                
                Text("male")
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                    TextViewLableText(text: "5.0", textFont: .headline)
                    Text("(100)")
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
}

#Preview {
    UserInfoCardView()
}
