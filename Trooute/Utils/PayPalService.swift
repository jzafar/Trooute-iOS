//
//  PayPalService.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-23.
//

import PayPalCheckout

struct PayPalService {
    static func configure() {
        let config = CheckoutConfig(
            clientID: isSandbox ? Constants.PAYPAL_CLIENT_ID_SandBox : Constants.PAYPAL_CLIENT_ID,
            environment: isSandbox ? .sandbox : .live
        )
        Checkout.set(config: config)
    }

    static var isSandbox: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var clientID: String {
        return isSandbox ? Constants.PAYPAL_CLIENT_ID_SandBox : Constants.PAYPAL_CLIENT_ID
    }

    static var secret: String {
        return isSandbox ? Constants.PAYPAL_SECRET_SandBox : Constants.PAYPAL_SECRET
    }

    static var userInfoURL: String {
        return isSandbox
            ? "https://api.sandbox.paypal.com/v1/identity/openidconnect/userinfo/?schema=openid"
            : "https://api.paypal.com/v1/identity/openidconnect/userinfo/?schema=openid"
    }

    static var authUrl: String {
        return isSandbox
            ? "https://api.sandbox.paypal.com/v1/oauth2/token"
            : "https://api.paypal.com/v1/oauth2/token"
    }

    static var signInUrl: String {
        let scope = "openid email".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "openid%20email"
        let redirectUriEncoded = Constants.redirectUri
        let baseUrl = isSandbox ? "https://www.sandbox.paypal.com" : "https://www.paypal.com"
        return "\(baseUrl)/signin/authorize?response_type=code&client_id=\(clientID)&redirect_uri=\(redirectUriEncoded)&scope=\(scope)"
    }
}
