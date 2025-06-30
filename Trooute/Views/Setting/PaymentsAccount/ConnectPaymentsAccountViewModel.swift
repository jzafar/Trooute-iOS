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
        if (userModel.user?.payPalEmail) != nil {
            isPayPalConnected = true
        }
        
        if (userModel.user?.stripeConnectedAccountId) != nil {
            isStripeConnected = true
        }
    }
    
    func connectStripeAccount() {
        SwiftLoader.show(title: "connecting...", animated: true)
        repository.connectStripeAccount { result in
            SwiftLoader.hide()
            switch result {
                case let .success(response):
                    if response.data.success,
                       let user = response.data.data {
                        UserUtils.shared.saveUserToStorage(user: user)
                        BannerHelper.displayBanner(.info, message: String(localized: "We have sent you an email. You can configure your Stripe account through the email."))
                    } else {
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                    
                case let .failure(error):
                    log.error("failed to get me \(error.localizedDescription)")
                    BannerHelper.displayBanner(.error, message: error.localizedDescription)
            }
        }
       
    }
    
    func loginWithPayPal() {
        PayPalAuthManager().login { code in
            guard let code = code else {
                BannerHelper.displayBanner(.error, message: String(localized: "Something went wrong. Please try again."))
                return
            }
            self.updatePaypalOnServer(code: code)

        }
    }
    
    private func updatePaypalOnServer(code: String) {
        SwiftLoader.show(title: "updating...", animated: true)
        repository.updatePaypalToServer(request: UpdatePaypalRequest(code: code)) { result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success,
                   let user = response.data.data {
                    UserUtils.shared.saveUserToStorage(user: user)
                    DispatchQueue.main.async {
                        self.isPayPalConnected = true
                    }
                    BannerHelper.displayBanner(.success, message: response.data.message)
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }

            case let .failure(error):
                log.error("failed to get me \(error.localizedDescription)")
                    BannerHelper.displayBanner(.error, message: error.localizedDescription)
            }
           
        }
    }
}
