//
//  ConnectPaymentsAccountView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-27.
//

import SwiftUI

struct ConnectPaymentsAccountView: View {
    @StateObject var viewModel = ConnectPaymentsAccountViewModel()
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.isPayPalConnected {
                        HStack {
                            Text("Paypal")
                            Spacer()
                            greenCircle
                        }
                    } else {
                        Button("Connect Paypal Account") {
                            viewModel.loginWithPayPal()
                        }
                    }

                    if viewModel.isStripeConnected {
                        HStack {
                            Text("Stripe Account")
                            Spacer()
                            greenCircle
                        }
                    } else {
                        Button("Connect Strip Account") {
                            viewModel.connectStripeAccount()
                        }
                    }
                } header: {
                    Text("You can connect your payments account.")
                } footer: {
                    Text("You can still choose how user can pay you when you create a trip.")
                }

            }.navigationTitle("Connect Payments Account")
                .toolbar(.hidden, for: .tabBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarRole(.editor)
        }
    }

    var greenCircle: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 15, height: 15)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}
