//
//  PayPalService.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-23.
//

struct PayPalService {
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
    
    static var payPal_URL: String {
        return isSandbox ? "https://www.sandbox.paypal.com/signin/authorize" : "https://www.paypal.com/signin/authorize"
    }

}
