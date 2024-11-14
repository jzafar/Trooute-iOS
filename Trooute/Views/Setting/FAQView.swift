//
//  FAQView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-24.
//

import SwiftUI

struct FAQView: View {
    @StateObject var viewModel = FAQViewModel()
    var body: some View {
        List(0..<6) { index in
            VStack(alignment: .leading) {
                HStack {
                    TextViewLableText(text: viewModel.faqArray[index].title)
                    Spacer()
                    Button(action: {
                        // Toggle expand/collapse state
                        if viewModel.expandedCells.contains(index) {
                            viewModel.expandedCells.remove(index)
                        } else {
                            viewModel.expandedCells.insert(index)
                        }
                    }) {
                        Image(systemName: viewModel.expandedCells.contains(index) ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }.buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                if viewModel.expandedCells.contains(index) {
                    Text(viewModel.faqArray[index].details)
                        .padding([.leading, .bottom, .trailing])
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .background(Color.white)
            .padding(.vertical, 5)
            .listRowSeparator(.hidden)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray, lineWidth: 1)
            )
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Frequently asked questions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
    }
}

//#Preview {
//    FAQView()
//}
