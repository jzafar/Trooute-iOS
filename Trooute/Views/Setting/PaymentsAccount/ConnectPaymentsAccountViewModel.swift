//
//  ConnectPaymentsAccountViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-27.
//
import Foundation
import SwiftLoader
class ConnectPaymentsAccountViewModel: ObservableObject {
    let userModel: UserUtils = UserUtils.shared
    @Published var isPayPalConnected: Bool = false
    @Published var isStripeConnected: Bool = false
    private let repository = ConnectAccountRepository()
    var paypalEmail: String?
    init() {
        if (userModel.user?.paypal) != nil {
            isPayPalConnected = true
        }
        
        if (userModel.user?.stripeConnectedAccountId) != nil {
            isStripeConnected = true
        }
    }
    
    func connectStripeAccount() {
        BannerHelper.displayBanner(.info, message: String(localized: "We have send you email. You can configure your stripe account throught emai."))
    }
    
    func connectPayPal() {
        repository.connectPaypal {  [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success {
                    if let payPal = response.data.data {
                        self?.updatePaypalOnServer(payPal: payPal)
                    }
                    
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case let .failure(failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }            
        }
    }
    
    private func updatePaypalOnServer(payPal: PayPalLoginData) {
        SwiftLoader.show(title: "updating...", animated: true)
        repository.updatePaypalToServer(request: UpdatePaypalRequest(payPalEmail: payPal.email)) { result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success,
                   let user = response.data.data {
                    UserUtils.shared.saveUserToStorage(user: user)
                }

            case let .failure(error):
                log.error("failed to get me \(error.localizedDescription)")
            }
           
        }
    }
}
