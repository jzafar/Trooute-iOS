//
//  SharedViews.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//
import SwiftUI

struct ProfilePictureView: View {
    let width: CGFloat
    let height: CGFloat
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Circle().stroke(Color.black, lineWidth: 1)
                .frame(width: width, height: width)
                .overlay(
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                )
                .foregroundColor(Color(UIColor.systemGray5))
        }
    }
}
