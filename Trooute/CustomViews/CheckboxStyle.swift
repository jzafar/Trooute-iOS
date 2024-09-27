//
//  CheckboxStyle.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-27.
//
import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.primaryGreen)
                .onTapGesture {
                    configuration.isOn.toggle()
                }

            configuration.label
        }
    }
}
