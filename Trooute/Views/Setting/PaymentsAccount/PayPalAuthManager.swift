//
//  PayPalAuthManager.swift
//  Trooute
//
//  Created by Muhammad Jahangir Zafar on 2025-05-16.
//
import AuthenticationServices
import Foundation

class PayPalAuthManager: NSObject {
    private var authSession: ASWebAuthenticationSession?
    
    func login(completion: @escaping (String?) -> Void) {
        let clientID = PayPalService.clientID
        let redirectURI = Constants.payPalredirectUri
        let scope = "openid email https://uri.paypal.com/services/paypalattributes"
        guard let encodedRedirectURI = redirectURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedScope = scope.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode redirect URI or scope")
            completion(nil)
            return
        }
        
        let urlString = "\(PayPalService.payPal_URL)?client_id=\(clientID)&response_type=code&scope=\(encodedScope)&redirect_uri=\(encodedRedirectURI)&nonce=\(UUID().uuidString)"
        
        guard let authURL = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "paypal") { callbackURL, error in
            guard
                error == nil,
                let url = callbackURL,
                let code = URLComponents(string: url.absoluteString)?
                    .queryItems?.first(where: { $0.name == "code" })?.value
            else {
                completion(nil)
                return
            }
            completion(code)
        }
        
        authSession?.presentationContextProvider = self
        authSession?.start()
    }
}

extension PayPalAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

