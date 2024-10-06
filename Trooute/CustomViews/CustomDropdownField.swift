//
//  CustomDropdownField.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-06.
//

import SwiftUI

struct CustomDropdownField: View {
    var title: String
    var placeholder: String
    var options: [String]
    @Binding var selectedValue: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
            }
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selectedValue = option }
                }
            } label: {
                Text(selectedValue.isEmpty ? placeholder : selectedValue)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
}
